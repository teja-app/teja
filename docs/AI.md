# This is the process that would make it easier.

## 1. Start from the API


### 1.1 Prompt

> This is the API Client Implement for Flutter, can you implemented the featured journal template API, DTO and Entity in a similar way
```{Entire Module of Nest.js or the API which is implemented would be better}```
```{Provide the files of API DTO and Entity too}```

**Generated File:** 

+ `lib/infrastructure/api/featured_journal_template_api.dart`
+ `lib/domain/entities/featured_journal_template_entity.dart`
+ `lib/infrastructure/dto/featured_journal_template_dto.dart`

### 1.2 Build the DTO:
`flutter pub run build_runner build --delete-conflicting-output`


## 2. Let's Build the Redux Actions and States without an store

### 2.1  Prompt

> Based on the `FeaturedJournalTemplateApi` and the example of the `Example Code` given below create similar actions, reducer, saga and state for the `FeaturedJournalTemplate`

**Note:** This should generate all the code for Redux, but since you might have given a saga which have repository it can give you the code with repository.

Generated Folder
+ `lib/domain/redux/journal/featured_journal_template`

### 2.2 Modifying Sagas, Reducers and States to App

[State](/lib/domain/redux/app_state.dart)
[Reducer](/lib/domain/redux/app_reducer.dart)
[Root Saga](/lib/domain/redux/root_saga.dart)


### 2.3 Restart App from CLI

`Cmd+C` - Closing the application 🤪


## 3. Implementing the Frontend

### 1. Call the API 

+ In [Onboarding](/lib/presentation/onboarding/pages/onboarding_page.dart)
+ Anywhere you prefer where it's needed

### 2. Implement the ViewModel

+ Implement the state ViewModel to implement the consumption of the state. Example [ExplorePageViewModel in explorepage](/lib/presentation/explore/list/pages/explore_page.dart)
+ Consume like on [Explore Page in ExplorePageState](/lib/presentation/explore/list/pages/explore_page.dart)


