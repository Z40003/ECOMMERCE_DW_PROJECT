package src.data_generator.java_generator;

public class Main {
    public static void main(String[] args) throws Exception {
        UserGenerator.main(args);
        ProductGenerator.main(args);
        OrderGenerator.main(args);
        ActionLogGenerator.main(args);
        DataPreviewTest.main(args);
        System.out.println("全部数据生成完成");
    }
}