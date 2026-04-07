package src.data_generator.java_generator;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.HashSet;
import java.util.Set;

public class MockDataUtil {
    public static final Random RANDOM = new Random(42);

    public static final Path OUTPUT_DIR = Path.of("mock_output");

    // 数据生成时间范围 2025.10.1 - 2025.12.31
    public static final LocalDateTime START = LocalDateTime.of(2025, 10, 1, 0, 0, 0);
    public static final LocalDateTime END = LocalDateTime.of(2025, 12, 31, 23, 59, 59);

    // 城市列表
    public static final String[] CITIES = {
            "北京", "上海", "杭州", "深圳", "广州", "成都",
            "武汉", "南京", "西安", "重庆", "苏州", "长沙"
    };

    // 品牌列表
    public static final String[] BRANDS = {
            "华为", "小米", "联想", "耐克", "阿迪达斯", "李宁",
            "美的", "海尔", "完美日记", "百雀羚", "三只松鼠", "良品铺子",
            "机械工业出版社", "人民邮电出版社", "安踏", "特步"
    };

    // 类别数据
    public static final String[][] CATEGORY_DATA = {
            { "1", "电子产品", "0" },
            { "2", "手机", "1" },
            { "3", "电脑", "1" },
            { "4", "平板", "1" },
            { "5", "耳机", "1" },
            { "6", "服饰", "0" },
            { "7", "外套", "6" },
            { "8", "鞋子", "6" },
            { "9", "裤子", "6" },
            { "10", "卫衣", "6" },
            { "11", "家居", "0" },
            { "12", "床品", "11" },
            { "13", "厨具", "11" },
            { "14", "收纳", "11" },
            { "15", "小家电", "11" },
            { "16", "美妆", "0" },
            { "17", "护肤", "16" },
            { "18", "彩妆", "16" },
            { "19", "面膜", "16" },
            { "20", "香水", "16" },
            { "21", "食品", "0" },
            { "22", "零食", "21" },
            { "23", "饮料", "21" },
            { "24", "速食", "21" }
    };

    // 随机生成时间 时间 ->秒（计算）->时间
    public static LocalDateTime randomDateTime(LocalDateTime start, LocalDateTime end) {
        long startSecond = start.toEpochSecond(java.time.ZoneOffset.ofHours(8));
        long endSecond = end.toEpochSecond(java.time.ZoneOffset.ofHours(8));
        long randomSecond = startSecond + (long) (RANDOM.nextDouble() * (endSecond - startSecond));
        return LocalDateTime.ofEpochSecond(randomSecond, 0, java.time.ZoneOffset.ofHours(8));
    }

    // 随机生成手机号码
    private static final Set<String> PHONE_SET = new HashSet<>();

    private static final String[] PHONE_PREFIX = {
            "130", "131", "132", "133", "134", "135", "136", "137", "138", "139",
            "150", "151", "152", "153", "155", "156", "157", "158", "159",
            "166",
            "177", "178",
            "180", "181", "182", "183", "184", "185", "186", "187", "188", "189",
            "198", "199"
    };

    public static String randomPhone() {

        while (true) {

            String prefix = PHONE_PREFIX[RANDOM.nextInt(PHONE_PREFIX.length)];

            String phone = prefix + randomDigits(8);

            if (PHONE_SET.add(phone)) {
                return phone;
            }

        }
    }

    public static String randomDigits(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            sb.append(RANDOM.nextInt(10));
        }
        return sb.toString();
    }

    // 城市对应的省份信息
    public static String cityToProvince(String city) {
        switch (city) {
            case "北京":
                return "北京";
            case "上海":
                return "上海";
            case "杭州":
                return "浙江";
            case "深圳":
            case "广州":
                return "广东";
            case "成都":
                return "四川";
            case "武汉":
                return "湖北";
            case "南京":
            case "苏州":
                return "江苏";
            case "西安":
                return "陕西";
            case "重庆":
                return "重庆";
            case "长沙":
                return "湖南";
            default:
                return "未知";
        }
    }

    // 随机生成支付方式
    public static String randomPaymentType() {
        String[] arr = { "alipay", "wechat", "bankcard" };
        return arr[RANDOM.nextInt(arr.length)];
    }

    // 随机生成商品价格
    public static BigDecimal randomPriceByCategory(String categoryName) {
        double value;
        switch (categoryName) {
            case "手机":
            case "电脑":
            case "平板":
                value = 1500 + RANDOM.nextDouble() * 8000;
                break;
            case "耳机":
                value = 99 + RANDOM.nextDouble() * 900;
                break;
            case "外套":
            case "鞋子":
            case "裤子":
            case "卫衣":
                value = 79 + RANDOM.nextDouble() * 600;
                break;
            case "护肤":
            case "彩妆":
            case "面膜":
            case "香水":
                value = 39 + RANDOM.nextDouble() * 500;
                break;
            case "床品":
            case "厨具":
            case "收纳":
            case "小家电":
                value = 49 + RANDOM.nextDouble() * 1000;
                break;
            case "零食":
            case "饮料":
            case "速食":
                value = 5 + RANDOM.nextDouble() * 100;
                break;
            default:
                value = 20 + RANDOM.nextDouble() * 300;
        }
        return BigDecimal.valueOf(value).setScale(2, RoundingMode.HALF_UP);
    }

    public static List<String[]> readCsv(Path file) throws IOException {
        List<String[]> rows = new ArrayList<>();
        try (BufferedReader br = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
            String line;
            boolean first = true;
            while ((line = br.readLine()) != null) {
                if (first) {
                    first = false;
                    continue;
                }
                rows.add(line.split(",", -1));
            }
        }
        return rows;
    }
}