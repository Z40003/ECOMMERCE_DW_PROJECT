package src.data_generator.java_generator;

import java.io.BufferedWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class UserGenerator {

    private static final int USER_COUNT = 10_000;

    public static void main(String[] args) throws Exception {
        Files.createDirectories(MockDataUtil.OUTPUT_DIR);

        Path file = MockDataUtil.OUTPUT_DIR.resolve("user_info.csv");
        try (BufferedWriter bw = Files.newBufferedWriter(file, StandardCharsets.UTF_8)) {
            bw.write(
                    "user_id,username,phone,gender,birthday,city,register_time,user_level,user_status,create_time,update_time\n");

            for (int i = 1; i <= USER_COUNT; i++) {
                String username = "user_" + String.format("%05d", i);
                String phone = MockDataUtil.randomPhone();
                String gender = MockDataUtil.RANDOM.nextBoolean() ? "男" : "女";
                LocalDate birthday = LocalDate.of(
                        1985 + MockDataUtil.RANDOM.nextInt(18),
                        1 + MockDataUtil.RANDOM.nextInt(12),
                        1 + MockDataUtil.RANDOM.nextInt(28));
                String city = MockDataUtil.CITIES[MockDataUtil.RANDOM.nextInt(MockDataUtil.CITIES.length)];
                LocalDateTime registerTime = MockDataUtil.randomDateTime(
                        MockDataUtil.START.minusDays(180), MockDataUtil.END.minusDays(5));
                String userLevel = MockDataUtil.RANDOM.nextDouble() < 0.80 ? "normal" : "vip";
                String userStatus = MockDataUtil.RANDOM.nextDouble() < 0.98 ? "active" : "disabled";
                LocalDateTime createTime = registerTime;
                LocalDateTime updateTime = registerTime.plusDays(MockDataUtil.RANDOM.nextInt(20));

                bw.write(String.format(
                        "%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s%n",
                        i, username, phone, gender, birthday, city,
                        registerTime, userLevel, userStatus, createTime, updateTime));
            }
        }

        System.out.println("user_info.csv 生成完成");
    }
}