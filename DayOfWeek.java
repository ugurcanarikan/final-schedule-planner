/**
 * Created by ugurcan on 14/04/2017.
 */
import java.util.InputMismatchException;
import java.util.Scanner;

/**
 * Finds Which day of the week the given date is
 * Takes 14 04 2014 Monday as the day of origin
 * Takes Input in the form DAY(int) MONTH(int) YEAR(int)
 * written at 14 05 2017 Friday by Ugurcan Arıkan
 */

public class DayOfWeek {
    //14 April 2014 taken as origin
    //14 April 2014 Monday
    public static final int originYear = 2014;
    final static int originMonth = 3;
    final static int originDay = 14;
    public static void main(String[] args) throws InputMismatchException{
        boolean keepAsking = true;              //boolean to keep if user wants to keep asking
        String days[] = new String[7];
        days[0]="Monday";
        days[1]="Tuesday";
        days[2]="Wednesday";
        days[3]="Thurday";
        days[4]="Friday";
        days[5]="Saturday";
        days[6]="Sunday";

        while(keepAsking) {
            System.out.println("Type the date you want to know or type \"exit\" to exit!");
            Scanner sc = new Scanner(System.in);
            String date = sc.nextLine();
            if(date.equals("exit")) {           //exit statement to stop the program
                keepAsking = false;
                break;
            }
            try {
                int month;
                int year;
                date = date.replaceAll("\\."," ");
                date = date.replaceAll("\\-"," ");
                date = date.replaceAll("\\/"," ");
                sc = new Scanner(date);
                int day = sc.nextInt();
                month = sc.nextInt() - 1;
                year = sc.nextInt();
                int totalCount;
                int yearCounter = 0;
                int monthCounter = 0;
                int dayCounter = 0;

                int startYear = Math.min(originYear, year);
                for (int i = 0; i < Math.abs(originYear - year); i++) {
                    if (((startYear + i) % 4 == 3) && ((startYear + i + 1) % 4 == 0))
                        yearCounter++;
                }
                yearCounter = yearCounter + Math.abs(originYear - year);
                yearCounter = yearCounter % 7;
                if (year < originYear)
                    yearCounter = 7 - yearCounter;

                int[] monthList = new int[12];
                monthList[0] = 31;
                if (year % 4 == 0)
                    monthList[1] = 28;
                else
                    monthList[1] = 29;
                monthList[2] = 31;
                monthList[3] = 30;
                monthList[4] = 31;
                monthList[5] = 30;
                monthList[6] = 31;
                monthList[7] = 31;
                monthList[8] = 30;
                monthList[9] = 31;
                monthList[10] = 30;
                monthList[11] = 31;

                int startMonth = Math.min(originMonth, month);
                int totalMonthDay = 0;
                for (int i = 0; i < Math.abs(originMonth - month); i++) {
                    totalMonthDay = totalMonthDay + monthList[startMonth + i];
                }
                monthCounter = totalMonthDay % 7;
                if (month < originMonth)
                    monthCounter = 7 - monthCounter;

                dayCounter = Math.abs(day - originDay);
                dayCounter = dayCounter % 7;
                if (day < originDay)
                    dayCounter = 7 - dayCounter;


                totalCount = yearCounter + monthCounter + dayCounter;
                totalCount = totalCount % 7;
                System.out.println(days[totalCount]);
            }
            catch(InputMismatchException exception){
                System.out.println("Type either a date or \"exit\"");
            }
        }
    }
}
