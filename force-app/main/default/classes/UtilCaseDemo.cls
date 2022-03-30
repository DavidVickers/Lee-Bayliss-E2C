public class UtilCaseDemo {
    
    public static void deleteAllCases(){
        List<case> cases = [select id from case];
        Delete cases;
    }

}