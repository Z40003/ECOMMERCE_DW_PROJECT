package src.data_generator.java_generator;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashSet;
import java.util.Set;

public class DataPreviewTest {

    public static void main(String[] args) throws Exception {
        Path outputDir = MockDataUtil.OUTPUT_DIR;

        System.out.println("========== 数据集预览开始 ==========");

        previewFile(outputDir.resolve("user_info.csv"), "user_info", 5, 0);
        previewFile(outputDir.resolve("category_info.csv"), "category_info", 5, 0);
        previewFile(outputDir.resolve("product_info.csv"), "product_info", 5, 0);
        previewFile(outputDir.resolve("order_info.csv"), "order_info", 5, 0);
        previewFile(outputDir.resolve("order_detail.csv"), "order_detail", 5, 0);
        previewFile(outputDir.resolve("payment_info.csv"), "payment_info", 5, 0);
        previewFile(outputDir.resolve("user_action_log.csv"), "user_action_log", 5, 0);

        System.out.println();
        System.out.println("========== 数据质量检查 ==========");

        checkDuplicateId(outputDir.resolve("user_info.csv"), "user_info", 0);
        checkDuplicateId(outputDir.resolve("category_info.csv"), "category_info", 0);
        checkDuplicateId(outputDir.resolve("product_info.csv"), "product_info", 0);
        checkDuplicateId(outputDir.resolve("order_info.csv"), "order_info", 0);
        checkDuplicateId(outputDir.resolve("order_detail.csv"), "order_detail", 0);
        checkDuplicateId(outputDir.resolve("payment_info.csv"), "payment_info", 0);
        checkDuplicateId(outputDir.resolve("user_action_log.csv"), "user_action_log", 0);

        System.out.println();
        System.out.println("========== 数量统计检查 ==========");

        long userCount = countDataLines(outputDir.resolve("user_info.csv"));
        long categoryCount = countDataLines(outputDir.resolve("category_info.csv"));
        long productCount = countDataLines(outputDir.resolve("product_info.csv"));
        long orderCount = countDataLines(outputDir.resolve("order_info.csv"));
        long detailCount = countDataLines(outputDir.resolve("order_detail.csv"));
        long paymentCount = countDataLines(outputDir.resolve("payment_info.csv"));
        long actionCount = countDataLines(outputDir.resolve("user_action_log.csv"));

        System.out.printf("user_info       : %,d%n", userCount);
        System.out.printf("category_info   : %,d%n", categoryCount);
        System.out.printf("product_info    : %,d%n", productCount);
        System.out.printf("order_info      : %,d%n", orderCount);
        System.out.printf("order_detail    : %,d%n", detailCount);
        System.out.printf("payment_info    : %,d%n", paymentCount);
        System.out.printf("user_action_log : %,d%n", actionCount);

        System.out.println();
        System.out.println("========== 比例检查 ==========");
        if (orderCount > 0) {
            double detailPerOrder = (double) detailCount / orderCount;
            double paymentRate = (double) paymentCount / orderCount;

            System.out.printf("平均每单明细数: %.2f%n", detailPerOrder);
            System.out.printf("支付订单占比  : %.2f%%%n", paymentRate * 100);
        }

        if (actionCount > 0) {
            previewActionTypeStats(outputDir.resolve("user_action_log.csv"));
        }

        System.out.println();
        System.out.println("========== 数据集预览结束 ==========");
    }

    private static void previewFile(Path file, String tableName, int previewRows, int idColumnIndex)
            throws IOException {
        System.out.println();
        System.out.println("---- " + tableName + " ----");

        if (!Files.exists(file)) {
            System.out.println("文件不存在: " + file.toAbsolutePath());
            return;
        }

        long count = countDataLines(file);
        System.out.println("文件路径: " + file.toAbsolutePath());
        System.out.println("数据行数: " + count);

        try (BufferedReader br = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
            String header = br.readLine();
            System.out.println("表头: " + header);
            System.out.println("前 " + previewRows + " 行预览:");

            String line;
            int i = 0;
            while ((line = br.readLine()) != null && i < previewRows) {
                System.out.println(line);
                i++;
            }
        }
    }

    private static long countDataLines(Path file) throws IOException {
        if (!Files.exists(file)) {
            return 0;
        }
        try (BufferedReader br = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
            long count = -1; // 去掉表头
            while (br.readLine() != null) {
                count++;
            }
            return Math.max(count, 0);
        }
    }

    private static void checkDuplicateId(Path file, String tableName, int idColumnIndex) throws IOException {
        if (!Files.exists(file)) {
            System.out.println(tableName + " 文件不存在，跳过检查");
            return;
        }

        Set<String> idSet = new HashSet<>();
        int duplicateCount = 0;

        try (BufferedReader br = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
            String line = br.readLine(); // header
            while ((line = br.readLine()) != null) {
                String[] arr = line.split(",", -1);
                if (arr.length <= idColumnIndex) {
                    continue;
                }
                String id = arr[idColumnIndex];
                if (!idSet.add(id)) {
                    duplicateCount++;
                }
            }
        }

        if (duplicateCount == 0) {
            System.out.println(tableName + " 主键检查通过，无重复");
        } else {
            System.out.println(tableName + " 主键检查异常，重复数: " + duplicateCount);
        }
    }

    private static void previewActionTypeStats(Path file) throws IOException {
        long view = 0;
        long cart = 0;
        long favor = 0;
        long order = 0;
        long pay = 0;
        long other = 0;

        try (BufferedReader br = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
            br.readLine(); // header
            String line;
            while ((line = br.readLine()) != null) {
                String[] arr = line.split(",", -1);
                if (arr.length < 4) {
                    continue;
                }
                String actionType = arr[3];
                switch (actionType) {
                    case "view":
                        view++;
                        break;
                    case "cart":
                        cart++;
                        break;
                    case "favor":
                        favor++;
                        break;
                    case "order":
                        order++;
                        break;
                    case "pay":
                        pay++;
                        break;
                    default:
                        other++;
                }
            }
        }

        long total = view + cart + favor + order + pay + other;
        System.out.println("行为类型分布:");
        printRatio("view ", view, total);
        printRatio("cart ", cart, total);
        printRatio("favor", favor, total);
        printRatio("order", order, total);
        printRatio("pay  ", pay, total);
        if (other > 0) {
            printRatio("other", other, total);
        }
    }

    private static void printRatio(String name, long count, long total) {
        double ratio = total == 0 ? 0 : (double) count / total * 100;
        System.out.printf("%s : %,d (%.2f%%)%n", name, count, ratio);
    }
}