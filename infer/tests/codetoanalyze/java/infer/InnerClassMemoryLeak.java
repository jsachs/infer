package codetoanalyze.java.infer;

private static Object inner;

void createInnerClass() {
    class InnerClass {
    }
    inner = new InnerClass();
}