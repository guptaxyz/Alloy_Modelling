import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;

public class AlloyInstanceCounter {
    public static void main(String[] args) throws Exception {

        System.out.println("Parsing the Alloy model...");

        String alloyModelPath = "recent.als"; 
        CompModule world = CompUtil.parseEverything_fromFile(null, null, alloyModelPath);

        Command command = world.getAllCommands().get(0);

        A4Options options = new A4Options();
        options.solver = A4Options.SatSolver.SAT4J;
        
        System.out.println("Solving the Alloy model...");

        A4Solution solution = TranslateAlloyToKodkod.execute_command(null, world.getAllReachableSigs(), command, options);
        int count = 0;

        // Iterate through all possible solutions and print each instance
        while (solution.satisfiable()) {
            count++;
            System.out.println("Instance #" + count);
            solution = solution.next(); 
        }

        System.out.println("Total satisfiable instances: " + count);
        System.out.println("All instances processed.");
    }
}
