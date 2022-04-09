package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

public class RegisterRequest {
    private String username;
    private String eMail;
    private String password;
    private String profilePicture;

    public RegisterRequest(String username, String eMail, String password, String profilePicture) {
        this.username = username;
        this.eMail = eMail;
        this.password = password;
        this.profilePicture = profilePicture;
    }

    public RegisterRequest() {
        super();
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String geteMail() {
        return eMail;
    }

    public void seteMail(String eMail) {
        this.eMail = eMail;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

}
