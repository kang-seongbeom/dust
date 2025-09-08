/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.maven.wrapper;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Properties;

/**
 * @author Hans Dockter
 */
public class MavenWrapperDownloader {

    private static final String WRAPPER_VERSION = "3.1.0";
    private static final String DEFAULT_DOWNLOAD_URL = "https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/" + WRAPPER_VERSION + "/maven-wrapper-" + WRAPPER_VERSION + ".jar";

    public static void main(String[] args) {
        System.out.println("- Downloading from: " + DEFAULT_DOWNLOAD_URL);
        try {
            downloadFileFromURL(DEFAULT_DOWNLOAD_URL, getWrapperJarPath());
            System.out.println("SUCCESS");
        } catch (IOException e) {
            System.out.println("- Error downloading: " + e.getMessage());
            System.exit(1);
        }
    }

    private static void downloadFileFromURL(String urlString, Path destination) throws IOException {
        URL website = new URL(urlString);
        try (InputStream inStream = website.openStream()) {
            Files.copy(inStream, destination, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    private static Path getWrapperJarPath() {
        return Paths.get(".mvn/wrapper/maven-wrapper.jar");
    }
}
