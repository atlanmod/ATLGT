package org.eclipse.m2m.atl.atlgt.groundtram;

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
class DefaultExecutor implements Executor {

    private final Path path;

    DefaultExecutor(Path path) {
        this.path = path;
    }

    @Override
    public int execute(String program, String... args) throws IOException {
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
