package src.data_generator.java_generator;

import java.io.BufferedWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;

public class ProductGenerator {

    private static final int PRODUCT_COUNT = 2_000;

    public static void main(String[] args) throws Exception {
        Files.createDirectories(MockDataUtil.OUTPUT_DIR);

        generateCategory();
        generateProduct();

        System.out.println("category_info.csv 和 product_info.csv 生成完成");
    }

    private static void generateCategory() throws Exception {
        Path file = MockDataUtil.OUTPUT_DIR.resolve("category_info.csv");
        try (BufferedWriter bw = Files.newBufferedWriter(file, StandardCharsets.UTF_8)) {
            bw.write("category_id,category_name,parent_category_id,create_time,update_time\n");

            LocalDateTime now = MockDataUtil.randomDateTime(MockDataUtil.START, MockDataUtil.END);
            for (String[] row : MockDataUtil.CATEGORY_DATA) {
                bw.write(String.format("%s,%s,%s,%s,%s%n",
                        row[0], row[1], row[2], now, now));
            }
        }
    }

    private static void generateProduct() throws Exception {
        Path file = MockDataUtil.OUTPUT_DIR.resolve("product_info.csv");
        try (BufferedWriter bw = Files.newBufferedWriter(file, StandardCharsets.UTF_8)) {
            bw.write("product_id,product_name,category_id,brand_name,price,product_status,create_time,update_time\n");

            for (int i = 1; i <= PRODUCT_COUNT; i++) {
                // 只从叶子类目选
                int idx = 1 + MockDataUtil.RANDOM.nextInt(MockDataUtil.CATEGORY_DATA.length - 1);
                while ("0".equals(MockDataUtil.CATEGORY_DATA[idx][2])) {
                    idx = 1 + MockDataUtil.RANDOM.nextInt(MockDataUtil.CATEGORY_DATA.length - 1);
                }

                String categoryId = MockDataUtil.CATEGORY_DATA[idx][0];
                String categoryName = MockDataUtil.CATEGORY_DATA[idx][1];
                String brand = MockDataUtil.BRANDS[MockDataUtil.RANDOM.nextInt(MockDataUtil.BRANDS.length)];
                String productName = brand + categoryName + (1000 + i);
                BigDecimal price = MockDataUtil.randomPriceByCategory(categoryName);
                String productStatus = MockDataUtil.RANDOM.nextDouble() < 0.95 ? "on_sale" : "off_sale";
                LocalDateTime createTime = MockDataUtil.randomDateTime(
                        MockDataUtil.START.minusDays(120), MockDataUtil.END.minusDays(1));
                LocalDateTime updateTime = createTime.plusDays(MockDataUtil.RANDOM.nextInt(30));

                bw.write(String.format(
                        "%d,%s,%s,%s,%s,%s,%s,%s%n",
                        i, productName, categoryId, brand, price, productStatus, createTime, updateTime));
            }
        }
    }
}