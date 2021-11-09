
1
git log -v --oneline --no-abbrev-commit | grep ^aefea
aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md

2
git log --oneline --no-abbrev-commit --tags | grep 85024d3
85024d3100126de36331c6982bfaac02cdab9e76 v0.12.23

3
git log --oneline --no-abbrev-commit --parents | grep ^b8d720
коммит b8d720f8340221f2146e4e4870bf2ee0bc48f2d5 
родитель 1 56cd7859e05c36c06b56d013b55a252d0bb7e158 
родитель 2 9ea88f22fc6269854151c571162c5bcf958bee2b 
Комментарий Merge pull request #23916 from hashicorp/cgriggs01-stable

4
git log --oneline v0.12.23..v0.12.24

33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release

5
git log -S'func providerSource(' --oneline
8c928e835 main: Consult local directories as potential mirrors of providers

6
git log -S 'globalPluginDirs' --oneline
35a058fb3 main: configure credentials from the CLI config file
c0b176109 prevent log output during init
8364383c3 Push plugin discovery down into command package

7
git log -S'synchronizedWriters'
....
#Первый коммит, содержащий определение этой функции, автор  коммита
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5

git show 5ac311e2a91e381e2f52234668b49ba670aa0fe5

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5

#Автор
Author: Martin Atkins <mart@degeneration.co.uk>

Date:   Wed May 3 16:25:41 2017 -0700

    main: synchronize writes to VT100-faker on Windows

    We use a third-party library "colorable" to translate VT100 color
    sequences into Windows console attribute-setting calls when Terraform is
    running on Windows.

    colorable is not concurrency-safe for multiple writes to the same console,
    because it writes to the console one character at a time and so two
    concurrent writers get their characters interleaved, creating unreadable
    garble.

    Here we wrap around it a synchronization mechanism to ensure that there
    can be only one Write call outstanding across both stderr and stdout,
    mimicking the usual behavior we expect (when stderr/stdout are a normal
    file handle) of each Write being completed atomically.

diff --git a/main.go b/main.go
index b94de2ebc..237581200 100644
--- a/main.go
+++ b/main.go
@@ -258,6 +258,15 @@ func copyOutput(r io.Reader, doneCh chan<- struct{}) {
        if runtime.GOOS == "windows" {
                stdout = colorable.NewColorableStdout()
                stderr = colorable.NewColorableStderr()
+
+               // colorable is not concurrency-safe when stdout and stderr are the
+               // same console, so we need to add some synchronization to ensure that
+               // we can't be concurrently writing to both stderr and stdout at
+               // once, or else we get intermingled writes that create gibberish
+               // in the console.
+               wrapped := synchronizedWriters(stdout, stderr)
+               stdout = wrapped[0]
+               stderr = wrapped[1]
        }
