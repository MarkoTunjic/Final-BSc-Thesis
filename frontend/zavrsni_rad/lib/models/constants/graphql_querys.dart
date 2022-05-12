const String recipes = """
  query Recipes(\$filter: Filter!){
    recipes(filter: \$filter)
    {
      recipes{
        user{
          id,
          username,
          profilePicture
        }
        id,
        averageRating,
        cookingDuration,
        coverPicture,
        recipeName,
        isLikedByCurrentUser
      }
      numberOfPages,
      currentIndex
    }
  }
""";

const String singleRecipe = """
  query SingleRecipe(\$recipeId: ID!){
    singleRecipe(recipeId:\$recipeId){
      id,
      coverPicture,
      recipeName,
      description,
      cookingDuration,
      averageRating,
      ratingFromCurrentUser,
      isApprooved,
      user{
        id,
        username,
        profilePicture
      }
      ingredients{
        ingredientName,
        quantity,
        measure
      }
      recipeSteps{
        orderNumber,
        stepDescription
      }
      images{
        link
      }
      videos{
        link
      }
      comments{
        id,
        commentText,
        user{
          id,
          username,
          profilePicture
        }
      }
    }
  }
""";

const String userForId = """
  query UserForId(\$userId: ID!){
    userForId(userId: \$userId){
      id,
      username,
      profilePicture
    }
  }
""";

const String notApproovedRecipes = """
  query NotApprovedRecipes(\$filter: Filter!){
    notApprovedRecipes(filter: \$filter){
      recipes{
        user{
          id,
          username,
          profilePicture
        }
        id,
        averageRating,
        cookingDuration,
        coverPicture,
        recipeName,
        isLikedByCurrentUser,
        isApprooved
      }
      numberOfPages,
      currentIndex
    }
  }
""";

const String users = """
  query Users(\$filter: Filter!){
    users(filter: \$filter){
      users{
        id,
        username,
        profilePicture,
        isBanned,
      }
      numberOfPages,
      currentIndex,
    }
  }
""";

const String favorites = """
  query Favorites(\$userId: ID!, \$filter: Filter!){
    favorites(userId: \$userId,filter: \$filter){
      recipes{
        user{
          id,
          username,
          profilePicture
        }
        id,
        averageRating,
        cookingDuration,
        coverPicture,
        recipeName,
        isLikedByCurrentUser
      }
      numberOfPages,
      currentIndex
    }
  }
""";
