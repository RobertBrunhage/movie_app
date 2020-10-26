# Flutter Movie App

[![Tutorial](https://img.youtube.com/vi/soTEOI_rIIQ/0.jpg)](https://www.youtube.com/watch?v=soTEOI_rIIQ)

This is an implementation using get_it, get_it_mixin and flutter_command.
Instead of flutter_command I could have added some `ValueNotifiers` but
as a `Command` already has all of them build-in, I decided to use it too here

It actually has three implementations that slightly differ:

* `home.dart` only uses `watchX` to update the UI
* `home2.dart` does the same but uses the `toWidget()` extension method which makes look the build method much nicer.
* `howe3.dart` show how you can fully leverage the power of `Command` by separately handling data, busy state and errors while using `registerHandler()` from the get_it_mixin so that you don't need a `StatefulWidget` and don't have to care to dispose anything.