package src.data_generator.java_generator;

import java.io.BufferedWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

public class ActionLogGenerator {

    private static final int ACTION_LOG_COUNT = 400_000;

    public static void main(String[] args) throws Exception {
        Files.createDirectories(MockDataUtil.OUTPUT_DIR);

        List<String[]> users = MockDataUtil.readCsv(MockDataUtil.OUTPUT_DIR.resolve("user_info.csv"));
        List<String[]> products = MockDataUtil.readCsv(MockDataUtil.OUTPUT_DIR.resolve("product_info.csv"));
        List<String[]> orders = MockDataUtil.readCsv(MockDataUtil.OUTPUT_DIR.resolve("order_info.csv"));
        List<String[]> payments = MockDataUtil.readCsv(MockDataUtil.OUTPUT_DIR.resolve("payment_info.csv"));

        if (users.isEmpty() || products.isEmpty()) {
            throw new RuntimeException("请先生成 user_info.csv 和 product_info.csv");
        }

        Path file = MockDataUtil.OUTPUT_DIR.resolve("user_action_log.csv");
        try (BufferedWriter bw = Files.newBufferedWriter(file, StandardCharsets.UTF_8)) {
            bw.write("action_id,user_id,product_id,action_type,action_time\n");

            long actionId = 1L;

            int viewCount = 300_000;
            int cartCount = 40_000;
            int favorCount = 32_000;
            int orderCount = 20_000;
            int payCount = 8_000;

            for (int i = 0; i < viewCount; i++) {
                String[] user = users.get(MockDataUtil.RANDOM.nextInt(users.size()));
                String[] product = products.get(MockDataUtil.RANDOM.nextInt(products.size()));
                LocalDateTime t = MockDataUtil.randomDateTime(MockDataUtil.START, MockDataUtil.END);
                bw.write(String.format("%d,%s,%s,view,%s%n", actionId++, user[0], product[0], t));
            }

            for (int i = 0; i < cartCount; i++) {
                String[] user = users.get(MockDataUtil.RANDOM.nextInt(users.size()));
                String[] product = products.get(MockDataUtil.RANDOM.nextInt(products.size()));
                LocalDateTime t = MockDataUtil.randomDateTime(MockDataUtil.START, MockDataUtil.END);
                bw.write(String.format("%d,%s,%s,cart,%s%n", actionId++, user[0], product[0], t));
            }

            for (int i = 0; i < favorCount; i++) {
                String[] user = users.get(MockDataUtil.RANDOM.nextInt(users.size()));
                String[] product = products.get(MockDataUtil.RANDOM.nextInt(products.size()));
                LocalDateTime t = MockDataUtil.randomDateTime(MockDataUtil.START, MockDataUtil.END);
                bw.write(String.format("%d,%s,%s,favor,%s%n", actionId++, user[0], product[0], t));
            }

            Collections.shuffle(orders, MockDataUtil.RANDOM);
            for (int i = 0; i < orderCount; i++) {
                String[] order = orders.get(i % orders.size());
                long productId = 1 + MockDataUtil.RANDOM.nextInt(2000);
                LocalDateTime t = LocalDateTime.parse(order[5]).minusMinutes(MockDataUtil.RANDOM.nextInt(30));
                bw.write(String.format("%d,%s,%d,order,%s%n", actionId++, order[1], productId, t));
            }

            Collections.shuffle(payments, MockDataUtil.RANDOM);
            for (int i = 0; i < payCount; i++) {
                String[] payment = payments.get(i % payments.size());
                long productId = 1 + MockDataUtil.RANDOM.nextInt(2000);
                LocalDateTime t = LocalDateTime.parse(payment[6]);
                bw.write(String.format("%d,%s,%d,pay,%s%n", actionId++, payment[2], productId, t));
            }
        }

        System.out.println("user_action_log.csv 生成完成，总数：" + ACTION_LOG_COUNT);
    }
}