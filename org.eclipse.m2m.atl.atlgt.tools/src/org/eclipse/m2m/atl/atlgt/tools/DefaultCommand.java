package org.eclipse.m2m.atl.atlgt.tools;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 */
public class DefaultCommand implements Command {

    private final Path path;

    private final String program;

    protected DefaultCommand(Path path, String program) {
        this.path = path;
        this.program = program;
    }

    @Override
    public int execute(String... args) throws IOException {
        List<String> command = new ArrayList<>();
        command.add(path.resolve(program).toString());
        command.addAll(Arrays.asList(args));

        ProcessBuilder pb = new ProcessBuilder();
        pb.command(command);
        pb.redirectErrorStream(true);
        pb.redirectOutput();

        Process process = pb.start();
        try {
            int result = process.waitFor();

            printStream(process.getInputStream());

            return result;
        }
        catch (InterruptedException e) {
            e.printStackTrace();
            throw new IOException(e);
        }
    }

    private void printStream(InputStream stream) throws IOException {
        String line;
        try (BufferedReader input = new BufferedReader(new InputStreamReader(stream))) {
            while ((line = input.readLine()) != null) {
                System.out.println(line);
            }
        }
    }
}
