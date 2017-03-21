package edu.columbia.cs.infers;

import android.app.Application;
import android.content.Context;

import com.squareup.leakcanary.LeakCanary;
import com.squareup.leakcanary.RefWatcher;

/**
 * Created by Alon on 21/03/2017.
 */

public class LeakCaneryApplication extends Application {

    private RefWatcher refWatcher;

    @Override
    public void onCreate(){
        super.onCreate();
        if (LeakCanary.isInAnalyzerProcess(this)) {
            // This process is dedicated to LeakCanary for heap analysis.
            // You should not init your app in this process.
            return;
        }
        refWatcher = LeakCanary.install(this);
    }

    public static RefWatcher getRefWatcher(Context context) {
        LeakCaneryApplication application = (LeakCaneryApplication) context.getApplicationContext();
        return application.refWatcher;
    }
}
