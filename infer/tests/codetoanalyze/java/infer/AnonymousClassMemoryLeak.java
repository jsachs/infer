package codetoanalyze.java.infer;

void startAsyncTask() {
    new AsyncTask<Void, Void, Void>() {
        @Override protected Void doInBackground(Void... params) {
            while(true);
        }
    }.execute();
}