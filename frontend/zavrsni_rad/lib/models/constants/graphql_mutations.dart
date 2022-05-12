const String login = """
  mutation Login(\$identifier: String!,\$password: String!){
    login(identifier: \$identifier, password: \$password){
      token,
      user{
        id,
        username,
        eMail,
        profilePicture,
        role{
          roleName
        }
      }
    }
  }
""";

const String register = """
  mutation Register(\$payload: RegisterRequest!){
    register(payload: \$payload){
      username,
      eMail
    }
  }
""";

const String addRecipe = """
  mutation AddRecipe(\$payload: RecipePayload!){
    addRecipe(payload:\$payload){
      id
    }
  }
""";

const String editFavorite = """
  mutation EditFavorite(\$userId: ID!, \$recipeId: ID!, \$state: Boolean!){
    editFavorite(userId: \$userId, recipeId: \$recipeId, state: \$state)
  }
""";

const String deleteRecipe = """
  mutation DeleteRecipe(\$recipeId: ID!){
    deleteRecipe(recipeId: \$recipeId)
  }
""";

const String addComment = """
  mutation AddComment(\$userId: ID!, \$recipeId: ID!, \$commentText: String!){
    addComment(userId: \$userId, recipeId: \$recipeId, commentText: \$commentText){
      user{
        username,
        profilePicture
      }
      commentText,
      id
    }
  }
""";

const String addRatingAndComment = """
  mutation AddRatingAndComment(\$userId: ID!, \$recipeId: ID!, \$commentText: String!, \$ratingValue: Int!){
    addComment(userId: \$userId, recipeId: \$recipeId, commentText: \$commentText){
      user{
        username,
        profilePicture
      }
      commentText,
      id
    }
    addRating(userId: \$userId, recipeId: \$recipeId, ratingValue: \$ratingValue)
  }
""";

const String deleteComment = """
  mutation DeleteComment(\$commentId: ID!){
    deleteComment(commentId: \$commentId)
  }
""";

const String changeApproovedStatus = """
  mutation ChangeApproovedStatus(\$recipeId: ID!, \$isApprooved: Boolean!){
    changeApproovedStatus(recipeId: \$recipeId, isApprooved: \$isApprooved)
  }
""";

const String changeBanStatus = """
  mutation ChangeBanStatus(\$userId: ID!, \$banStatus: Boolean!){
    changeBanStatus(userId: \$userId, banStatus: \$banStatus)
  }
""";
