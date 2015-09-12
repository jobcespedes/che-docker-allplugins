FROM codenvy/shellinabox

ENV CHE_VERSION="3.12.2" \
    MAVEN_VERSION=3.2.2 \
    JAVA_VERSION=8u45 \
    JAVA_VERSION_PREFIX=1.8.0_45 \
    CHE_LOCAL_CONF_DIR=/home/user/.che

ENV JAVA_HOME=/opt/jdk$JAVA_VERSION_PREFIX \
    M2_HOME=/opt/apache-maven-$MAVEN_VERSION

ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

# Change default mirror
RUN sudo sed -i "s@http://http.debian.net@http://mirrors.ucr.ac.cr@" /etc/apt/sources.list

# Install required pckgs
RUN sudo apt-get update && sudo apt-get install -y -q git subversion nodejs npm build-essential && \
    sudo apt-get clean all && \
    git clone -b $CHE_VERSION https://github.com/codenvy/che.git /home/user/repo  && \
    sudo ln -s /usr/bin/nodejs /usr/bin/node && \
    sudo npm install -g grunt grunt-cli bower yo && \
    wget \
    --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    -qO- \
    "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-b14/jdk-$JAVA_VERSION-linux-x64.tar.gz" | sudo tar -zx -C /opt/ && \
    mkdir /opt/apache-maven-$MAVEN_VERSION/ && \
    sudo wget -qO- "https://archive.apache.org/dist/maven/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | sudo tar -zx --strip-components=1 -C /opt/apache-maven-$MAVEN_VERSION/

# Prepare env
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /home/user/.bashrc && \
    echo "export M2_HOME=$M2_HOME" >> /home/user/.bashrc && \
    mkdir -p /home/user/.che && \
    echo "export PATH=$PATH" >> /home/user/.bashrc && \
    cd /home/user/.che && \
    touch preferences.json profiles.json vfs && \
    echo "1q2w3e=/home/user/che/temp/fs-root" >> vfs && \
    echo "export CHE_LOCAL_CONF_DIR=$CHE_LOCAL_CONF_DIR" >> /home/user/.bashrc && \
    sudo chmod 757 -R /home/user/.che

# Add plugins as assembly dependencies.
RUN sed -i "0,/.*<dependency>.*/s@@                <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>angularjs-completion-dto</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>angularjs-core-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>angularjs-core-server</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-bower-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-bower-builder</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-codemirror-editorwidget</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-cpp-ext-cpp</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-docker-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-docker-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-git-ext-git</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-github-ext-github</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-github-provider-github</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-go-ext-go</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-grunt-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-gulp-runner</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-help-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-builder-ant</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-ext-debugger-java</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-ext-java</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-ext-java-codeassistant</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-ext-maven</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-generator-archetype</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-jdt-core-repack</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-jseditor</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-java-runner-webapps</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-npm-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-orion-editor</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-php-ext-php</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-python-ext-python</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-ruby-ext-ruby</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-sdk-env-local</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-sdk-ext-plugins</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-sdk-runner</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-ssh-git-native</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-svn-ext-subversion</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-tour-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-tour-hopscotch</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-tour-dto</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>\n\
        <dependency>\n\
            <groupId>org.eclipse.che.plugin</groupId>\n\
            <artifactId>che-plugin-yeoman-ext-client</artifactId>\n\
            <version>\${che.plugins.version}</version>\n\
        </dependency>&@" /home/user/repo/assembly-sdk-war/pom.xml

# If IDE dependency, also add it.
RUN sed -i "0,/.*<\/module>.*/s@@    <!-- Additional plugins-->\n\
    <inherits name='org.eclipse.che.plugin.angularjs.core.client.AngularJS'/>\n\
    <inherits name='org.eclipse.che.plugin.bower.client.Bower'/>\n\
    <inherits name='org.eclipse.che.ide.editor.codemirror.CodeMirrorEditor'/>\n\
    <inherits name='org.eclipse.che.ide.ext.cpp.CPP'/>\n\
    <inherits name='org.eclipse.che.plugin.docker.ext.client.Docker'/>\n\
    <inherits name='org.eclipse.che.ide.ext.git.Git'/>\n\
    <inherits name='org.eclipse.che.ide.ext.github.GitHub'/>\n\
    <inherits name='org.eclipse.che.ide.ext.go.Go'/>\n\
    <inherits name='org.eclipse.che.plugin.grunt.client.Grunt'/>\n\
    <inherits name='org.eclipse.che.ide.ext.help.HelpAboutExtension'/>\n\
    <inherits name='org.eclipse.che.ide.ext.java.Java'/>\n\
    <inherits name='org.eclipse.che.ide.jseditor.java.JsJavaEditor'/>\n\
    <inherits name='org.eclipse.che.ide.extension.ant.Ant'/>\n\
    <inherits name='org.eclipse.che.ide.ext.java.jdi.JavaRuntimeExtension'/>\n\
    <inherits name='org.eclipse.che.ide.extension.maven.Maven'/>\n\
    <inherits name='org.eclipse.che.plugin.npm.client.Npm'/>\n\
    <inherits name='org.eclipse.che.ide.editor.orion.OrionEditor'/>\n\
    <inherits name='org.eclipse.che.ide.ext.php.PHP'/>\n\
    <inherits name='org.eclipse.che.ide.ext.python.Python'/>\n\
    <inherits name='org.eclipse.che.ide.ext.ruby.Ruby'/>\n\
    <inherits name='org.eclipse.che.env.local.LocalEnvironment'/>\n\
    <inherits name='org.eclipse.che.ide.ext.ssh.Ssh'/>\n\
    <inherits name='org.eclipse.che.ide.ext.svn.Subversion'/>\n\
    <inherits name='org.eclipse.che.plugin.tour.client.Tour'/>\n\
    <inherits name='org.eclipse.che.ide.ext.tutorials.Tutorials'/>\n\
    <inherits name='org.eclipse.che.plugin.yeoman.client.Yeoman'/>\n&@" \
    /home/user/repo/assembly-sdk-war/src/main/resources/org/eclipse/che/ide/IDE.gwt.xml

# Assembly
RUN cd /home/user/repo && \
    mvn sortpom:sort && \
    mvn clean install

# Remove repo folders to free up space and shrink image.
RUN cp -r /home/user/repo/assembly-sdk/target/assembly-sdk-$CHE_VERSION/assembly-sdk-$CHE_VERSION/ /home/user/che && \
    sudo rm -rf /home/user/.m2/repository/* && \
    sudo rm -rf /home/user/repo && \
    sudo chmod 757 -R /home/user/che

# Initial properties file
ADD che.properties /home/user/.che/che.properties

# Initial working dir
WORKDIR /home/user/che

# expose 8080 port and a range of ports for runners
EXPOSE 8080 49152-49162
CMD ./bin/che.sh run
