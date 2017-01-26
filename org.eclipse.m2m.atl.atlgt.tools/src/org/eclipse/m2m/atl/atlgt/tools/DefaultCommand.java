package org.eclipse.m2m.atl.atlgt.tools;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * A default {@link Command} that executes a program using {@link ProcessBuilder}s and {@link Process}s.
 * <p>
 * The program output is redirected to the console.
 */
public class DefaultCommand implements Command {

    /**
     * The path to the execution of the command.
     */
    private final Path path;

    /**
     * The program to execute.
     */
    private final String executable;

    /**
     * Constructs a new {@code DefaultCommand} on the given {@code path} with the specified {@code program}.
     *
     * @param path       the path to the execution of the command
     * @param executable the program to execute
     */
    protected DefaultCommand(Path path, String executable) {
        this.path = path;
        this.executable = executable;
    }

    /**
     * Prints a {@code inputStream} in a {@code printStream}.
     *
     * @param inputStream the stream to print
     * @param printStream the stream where to print
     *
     * @throws IOException if an I/O error occurs
     */
    private static void printStream(InputStream inputStream, PrintStream printStream) throws IOException {
        try (BufferedReader input = new BufferedReader(new InputStreamReader(inputStream))) {
            String line;
            while ((line = input.readLine()) != null) {
                printStream.println("    > " + line);
            }
        }
    }

    @Override
    public int execute(String... args) {
        List<String> command = new ArrayList<>();
        command.add(path.resolve(executable).toString());
        command.addAll(Arrays.asList(args));

        ProcessBuilder pb = new ProcessBuilder()
                .command(command)
                .directory(path.toFile())
                .redirectErrorStream(true);

        System.out.println("Executing: " + executable + " " + Stream.of(args).collect(Collectors.joining(" ")));

        Process process = null;
        try {
            process = pb.start();
            int exitValue = process.waitFor();
            printStream(process.getInputStream(), System.out);

            if (exitValue != 0) {
                throw new RuntimeException("The execution ended with an error: " + exitValue + ". See the trace for more information");
            }
            return exitValue;
        }
        catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        catch (InterruptedException e) {
            e.printStackTrace();
            process.destroyForcibly();
            return 0;
        }
    }
}
