package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;

public class LoginResponse {
    private Users user;
    private String token;

    public LoginResponse(Users user, String token) {
        super();
        this.user = user;
        this.token = token;
    }

    public LoginResponse() {
        super();
    }

    public Users getUser() {
        return user;
    }

    public String getToken() {
        return token;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public void setToken(String token) {
        this.token = token;
    }

}
