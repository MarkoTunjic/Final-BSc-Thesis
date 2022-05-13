package hr.fer.zpr.marko_tunjic.zavrsni_rad.services;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import com.google.auth.Credentials;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;

import org.springframework.stereotype.Service;

@Service
public class FileService {
    public static final String DEFAULT_PROFILE_PICTURE = "https://firebasestorage.googleapis.com/v0/b/finalbscthesis.appspot.com/o/default_profile.png?alt=media";
    public static final String DEFAULT_RECIPE_PICTURE = "https://firebasestorage.googleapis.com/v0/b/finalbscthesis.appspot.com/o/default_recipe.png?alt=media";

    private static final String DOWNLOAD_URL = "https://firebasestorage.googleapis.com/v0/b/finalbscthesis.appspot.com/o/%s?alt=media";

    public String upload(String base64File, String fileName) throws FileNotFoundException, IOException {
        BlobId blobId = BlobId.of("finalbscthesis.appspot.com", fileName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("media").build();
        Credentials credentials = GoogleCredentials.fromStream(
                getClass().getResourceAsStream("/finalbscthesis-firebase-adminsdk-4hpv1-305070dc09.json"));
        Storage storage = StorageOptions.newBuilder().setCredentials(credentials).build().getService();
        storage.create(blobInfo, Base64.getDecoder().decode(base64File));
        return String.format(DOWNLOAD_URL, URLEncoder.encode(fileName, StandardCharsets.UTF_8));
    }

    public void delete(String url) throws FileNotFoundException, IOException {
        String name = url.substring(url.lastIndexOf("/") + 1, url.indexOf("?"));
        BlobId blobId = BlobId.of("finalbscthesis.appspot.com", name);
        Credentials credentials = GoogleCredentials.fromStream(
                getClass().getResourceAsStream("/finalbscthesis-firebase-adminsdk-4hpv1-305070dc09.json"));
        Storage storage = StorageOptions.newBuilder().setCredentials(credentials).build().getService();
        storage.delete(blobId);
    }
}
