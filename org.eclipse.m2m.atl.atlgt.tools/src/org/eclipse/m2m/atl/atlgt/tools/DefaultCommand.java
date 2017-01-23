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
    private final String program;

    /**
     * Constructs a new {@code DefaultCommand} on the given {@code path} with the specified {@code program}.
     *
     * @param path    the path to the execution of the command
     * @param program the program to execute
     */
    protected DefaultCommand(Path path, String program) {
        this.path = path;
        this.program = program;
    }

    @Override
    public int execute(String... args) {
        List<String> command = new ArrayList<>();
        command.add(path.resolve(program).toString());
        command.addAll(Arrays.asList(args));

        ProcessBuilder pb = new ProcessBuilder();
        pb.command(command);
        pb.redirectErrorStream(true);
        pb.redirectOutput();

        System.out.println("Executing: " + command.stream().collect(Collectors.joining(" ")));
        try {
            Process process = pb.start();
            int result = process.waitFor();
            printStream(process.getInputStream(), System.out);
            return result;
        }
        catch (IOException | InterruptedException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Prints a {@code inputStream} in a {@code printStream}.
     *
     * @param inputStream the stream to print
     * @param printStream the stream where to print
     *
     * @throws IOException if an I/O error occurs
     */
    private void printStream(InputStream inputStream, PrintStream printStream) throws IOException {
        try (BufferedReader input = new BufferedReader(new InputStreamReader(inputStream))) {
            String line;
            while ((line = input.readLine()) != null) {
                printStream.println("    > " + line);
            }
        }
    }
}
