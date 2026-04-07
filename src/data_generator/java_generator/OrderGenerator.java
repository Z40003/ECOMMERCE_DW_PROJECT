package src.data_generator.java_generator;

import java.io.BufferedWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.*;

public class OrderGenerator {

    private static final int ORDER_COUNT = 50_000;
    private static final int ORDER_DETAIL_COUNT = 90_000;
    private static final int PAYMENT_COUNT = 40_000;

    public static void main(String[] args) throws Exception {
        Files.createDirectories(MockDataUtil.OUTPUT_DIR);

        List<String[]> users = MockDataUtil.readCsv(MockDataUtil.OUTPUT_DIR.resolve("user_info.csv"));
        List<String[]> products = MockDataUtil.readCsv(MockDataUtil.OUTPUT_DIR.resolve("product_info.csv"));

        if (users.isEmpty() || products.isEmpty()) {
            throw new RuntimeException("请先生成 user_info.csv 和 product_info.csv");
        }

        generateOrders(users, products);
        System.out.println("order_info.csv / order_detail.csv / payment_info.csv 生成完成");
    }

    private static void generateOrders(List<String[]> users, List<String[]> products) throws Exception {
        Path orderFile = MockDataUtil.OUTPUT_DIR.resolve("order_info.csv");
        Path detailFile = MockDataUtil.OUTPUT_DIR.resolve("order_detail.csv");
        Path paymentFile = MockDataUtil.OUTPUT_DIR.resolve("payment_info.csv");

        try (
                BufferedWriter orderBw = Files.newBufferedWriter(orderFile, StandardCharsets.UTF_8);
                BufferedWriter detailBw = Files.newBufferedWriter(detailFile, StandardCharsets.UTF_8);
                BufferedWriter paymentBw = Files.newBufferedWriter(paymentFile, StandardCharsets.UTF_8)) {
            orderBw.write(
                    "order_id,user_id,order_status,total_amount,pay_amount,order_time,pay_time,province,city,create_time,update_time\n");
            detailBw.write(
                    "order_detail_id,order_id,product_id,product_num,product_price,original_amount,create_time\n");
            paymentBw.write(
                    "payment_id,order_id,user_id,payment_type,payment_status,payment_amount,payment_time,create_time\n");

            List<String[]> orderingUsers = new ArrayList<>(users);
            Collections.shuffle(orderingUsers, MockDataUtil.RANDOM);
            orderingUsers = orderingUsers.subList(0, users.size() / 2);

            List<Integer> detailCountPerOrder = new ArrayList<>();
            for (int i = 0; i < ORDER_COUNT; i++) {
                detailCountPerOrder.add(1);
            }

            int extra = ORDER_DETAIL_COUNT - ORDER_COUNT;
            while (extra > 0) {
                int idx = MockDataUtil.RANDOM.nextInt(ORDER_COUNT);
                if (detailCountPerOrder.get(idx) < 3) {
                    detailCountPerOrder.set(idx, detailCountPerOrder.get(idx) + 1);
                    extra--;
                }
            }

            long detailId = 1L;
            long paymentId = 1L;

            for (long orderId = 1; orderId <= ORDER_COUNT; orderId++) {
                String[] user = orderingUsers.get(MockDataUtil.RANDOM.nextInt(orderingUsers.size()));
                long userId = Long.parseLong(user[0]);
                String city = user[5];
                String province = MockDataUtil.cityToProvince(city);

                LocalDateTime orderTime = MockDataUtil.randomDateTime(MockDataUtil.START, MockDataUtil.END);

                String orderStatus;
                if (orderId <= PAYMENT_COUNT) {
                    orderStatus = "paid";
                } else {
                    double p = MockDataUtil.RANDOM.nextDouble();
                    orderStatus = p < 0.75 ? "cancelled" : "unpaid";
                }

                int itemCount = detailCountPerOrder.get((int) orderId - 1);

                BigDecimal totalAmount = BigDecimal.ZERO;
                Set<Long> usedProducts = new HashSet<>();

                for (int j = 0; j < itemCount; j++) {
                    String[] product;
                    long productId;
                    do {
                        product = products.get(MockDataUtil.RANDOM.nextInt(products.size()));
                        productId = Long.parseLong(product[0]);
                    } while (usedProducts.contains(productId));
                    usedProducts.add(productId);

                    int productNum = 1 + MockDataUtil.RANDOM.nextInt(3);
                    BigDecimal productPrice = new BigDecimal(product[4]);
                    BigDecimal originalAmount = productPrice.multiply(BigDecimal.valueOf(productNum))
                            .setScale(2, RoundingMode.HALF_UP);

                    totalAmount = totalAmount.add(originalAmount);

                    detailBw.write(String.format(
                            "%d,%d,%d,%d,%s,%s,%s%n",
                            detailId++, orderId, productId, productNum,
                            productPrice, originalAmount, orderTime));
                }

                BigDecimal payAmount = BigDecimal.ZERO;
                LocalDateTime payTime = null;

                if ("paid".equals(orderStatus)) {
                    double discount = 0.95 + MockDataUtil.RANDOM.nextDouble() * 0.05;
                    payAmount = totalAmount.multiply(BigDecimal.valueOf(discount))
                            .setScale(2, RoundingMode.HALF_UP);
                    payTime = orderTime.plusMinutes(5 + MockDataUtil.RANDOM.nextInt(120));

                    paymentBw.write(String.format(
                            "%d,%d,%d,%s,%s,%s,%s,%s%n",
                            paymentId++, orderId, userId,
                            MockDataUtil.randomPaymentType(),
                            "success",
                            payAmount,
                            payTime,
                            payTime));
                }

                orderBw.write(String.format(
                        "%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s%n",
                        orderId, userId, orderStatus,
                        totalAmount.setScale(2, RoundingMode.HALF_UP),
                        payAmount,
                        orderTime,
                        payTime == null ? "" : payTime.toString(),
                        province,
                        city,
                        orderTime,
                        orderTime.plusMinutes(MockDataUtil.RANDOM.nextInt(60))));
            }
        }
    }
}