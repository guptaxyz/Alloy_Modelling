import edu.mit.csail.sdg.alloy4compiler.translator.A4Options;
import edu.mit.csail.sdg.alloy4compiler.translator.A4Solution;
import edu.mit.csail.sdg.alloy4compiler.translator.TranslateAlloyToKodkod;
import edu.mit.csail.sdg.alloy4compiler.parser.CompUtil;
import edu.mit.csail.sdg.alloy4compiler.parser.CompModule;
import edu.mit.csail.sdg.alloy4compiler.ast.Command;

public class AlloyInstanceCounter {
    public static void main(String[] args) throws Exception {
        // Start progress for parsing the Alloy model
        System.out.println("Parsing the Alloy model...");

        String alloyModelPath = "recent.als";  // Specify the path to your Alloy model file
        CompModule world = CompUtil.parseEverything_fromFile(null, null, alloyModelPath);

        System.out.println("Model parsed successfully.");

        // Get the first command to run
        System.out.println("Extracting command from the model...");
        Command command = world.getAllCommands().get(0);  // Assuming you want the first command
        System.out.println("Command extracted.");

        // Set up the solver options
        A4Options options = new A4Options();
        options.solver = A4Options.SatSolver.SAT4J;

        // Start solving
        System.out.println("Solving the Alloy model...");

        // Execute the command and get the first solution
        A4Solution solution = TranslateAlloyToKodkod.execute_command(null, world.getAllReachableSigs(), command, options);
        int count = 0;

        // Iterate through all possible solutions and print each instance
        while (solution.satisfiable()) {
            count++;
            System.out.println("Found satisfiable instance #" + count);
            // System.out.println(solution);  // Print the Alloy solution instance

            // Progress update after each solution
            solution = solution.next();  // Get the next solution
        }

        // Print the total number of satisfiable instances
        System.out.println("Total satisfiable instances: " + count);
        System.out.println("All instances processed.");
    }
}
