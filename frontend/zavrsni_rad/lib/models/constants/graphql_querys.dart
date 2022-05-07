const String recipes = """
  query Recipes(\$filter: Filter!){
    recipes(filter: \$filter)
    {
      recipes{
        user{
          username,
          profilePicture
        }
        averageRating,
        cookingDuration,
        coverPicture,
        recipeName,
        isLikedByCurrentUser
      }
      numberOfPages
    }
  }
""";
