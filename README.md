# Big Red App for iOS

Yes, this is the iOS version of [Genki Marshall's](https://github.com/genkimarshall) [Big Red App](https://github.com/genkimarshall/bigredapp-android). As such, its goals are very similar.
 
## What
* It's still a pain to find Cornell University dining hall info on the phone, so this is the iOS app to help with that.
* We are using [Kevin Chavez](https://github.com/mrkev)'s API [here](http://redapi-tious.rhcloud.com/).

## Objectives
* Free and open source.
* Native iOS app: easy to use, good looking, minimal, clean.
* Code: well-commented and easy to maintain.

## Contributing
* [Pull requests](http://git-scm.com/book/en/v2/GitHub-Contributing-to-a-Project) are very welcome! Do not hesitate if you are a beginner, as I would be more than happy to give an overview of the project, or even iOS development in general.

## General App Structure
* All requests for JSON objects from the RedAPI are handled in the JSONRequest class.
* The LocationTableController class controls the table that displays of list of dining locations.
* The MenuViewController class controls the view that displays the menu for a particular location.
* The UI structure/layout is housed in Main.storyboard, a standard nib file.

## Other
* [Facebook Group](https://www.facebook.com/groups/opensourcecornell)
* Questions? Feel free to email me (Matthew Gharrity): mjg355
