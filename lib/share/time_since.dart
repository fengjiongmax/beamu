String timeSince(DateTime inputTime){
  String timeSince = '';
  var timeDiff = DateTime.now().difference(inputTime);
  if(timeDiff.inDays>365){
    timeSince += (timeDiff.inDays/365).round().toString() + " year"+((timeDiff.inDays/365).round()>1?"s":"")+" ago";
  }else if(timeDiff.inDays>30){
    timeSince += (timeDiff.inDays/30).round().toString() + " month"+((timeDiff.inDays/30).round()>1?"s":"")+" ago";
  }else if(timeDiff.inDays>0){
    timeSince += timeDiff.inDays.round().toString() + " day"+(timeDiff.inDays.round()>1?"s":"")+" ago";
  }else if(timeDiff.inHours>0){
    timeSince += timeDiff.inHours.round().toString() + " hour"+(timeDiff.inHours.round()>1?"s":"")+" ago";
  }else if(timeDiff.inMinutes>0){
    timeSince += timeDiff.inMinutes.round().toString() + " minute"+(timeDiff.inMinutes.round()>1?"s":"")+" ago";
  }else if(timeDiff.inSeconds>0){
    timeSince += timeDiff.inSeconds.round().toString() + " second"+(timeDiff.inSeconds.round()>1?"s":"")+" ago";
  }else{
    timeSince += "just now";
  }

  return timeSince;
}