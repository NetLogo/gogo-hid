ifeq ($(origin JAVA_HOME), undefined)
  JAVA_HOME=/usr
endif

ifeq ($(origin NETLOGO), undefined)
  NETLOGO=../..
endif

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

JAVAC:=$(JAVA_HOME)/bin/javac
SRCS=$(wildcard src/**/*.java)

gogo.jar gogo.jar.pack.gz: $(SRCS) manifest.txt Makefile
	mkdir -p classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.5 -target 1.5 -classpath $(NETLOGO)/NetLogoLite.jar:hid4java.jar:jna.jar -d classes $(SRCS)
	jar cmf manifest.txt gogo.jar -C classes .
	pack200 --modification-time=latest --effort=9 --strip-debug --no-keep-file-order --unknown-attribute=strip gogo.jar.pack.gz gogo.jar

gogo.zip: gogo.jar
	rm -rf gogo
	mkdir gogo
	cp -rp gogo.jar gogo.jar.pack.gz README.md Makefile src manifest.txt gogo
	zip -rv gogo.zip gogo
	rm -rf gogo
