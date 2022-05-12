package hr.fer.zpr.marko_tunjic.zavrsni_rad.graphql.payloads;

import java.util.List;

import hr.fer.zpr.marko_tunjic.zavrsni_rad.models.Users;

public class UsersResponse {
    private List<Users> users;
    private Integer numberOfPages;
    private Integer currentIndex;

    public UsersResponse(List<Users> users, Integer numberOfPages, Integer currentIndex) {
        this.users = users;
        this.numberOfPages = numberOfPages;
        this.currentIndex = currentIndex;
    }

    public UsersResponse() {
        super();
    }

    public List<Users> getUsers() {
        return users;
    }

    public void setUsers(List<Users> users) {
        this.users = users;
    }

    public Integer getNumberOfPages() {
        return numberOfPages;
    }

    public void setNumberOfPages(Integer numberOfPages) {
        this.numberOfPages = numberOfPages;
    }

    public Integer getCurrentIndex() {
        return currentIndex;
    }

    public void setCurrentIndex(Integer currentIndex) {
        this.currentIndex = currentIndex;
    }

}
