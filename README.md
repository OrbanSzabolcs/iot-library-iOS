# iot-library-iOS


## Installation
Use 'pods' to add the library to your project:
```
pod 'IotLibrary'
```
In your 'AppDelegate' import
```
import IotLibrary
```

##### Setup only with token
```
IotTracker.shared.set(configuration: "YourApiKey")
```

##### Setup only with configuration
```
let configuarion = Configuration()
configuarion.token = "YourApiKey"
configuarion.minBatchSize = 5
configuarion.loggingEnabled = true
configuarion.debouncingIntervalInMinutes = 15

IotTracker.shared.set(configuration: configuarion)
```

## Configuration
- token:
  * This is the project API_KEY
  * An exception is thrown if token is not set: NoToken("You need to set token first.")

- minBatchSize:
  * By default, events are only sent by batches of 10.
  * If you set the minBatchSize to 1, then each event is sending to server as soon as it is tracked.

- loggingEnabled:
  * Logging is disabled by default
  * if you enable it, you can use IoT_Zynk_Software tag to check if the event was sent correctly.

- debouncingIntervalInMinutes:
  * Default and minimum value is 15 minutes.

## Usage
##### Track metric
```
IotTracker.shared.trackMetric(name: "name", tag: "tag", value: value)
```

##### Track log
```
IotTracker.shared.trackLog(logStream: "logStream", message: "message", value: value)
```

## Upload mechanism

#### OneTime upload
Every time a new event is stored, the following check is performed:
If the number of events is superior or equal to 'minBatchSize', an attempt at uploading all events is performed. If the attempt fails, because of a network issue for example, it will not be retried, and events remain stored. If you set 'minBatchSize' to  1, an upload attempt will be performed each time a new event is generated.

#### Periodic upload
Every 15 minutes, a job will run in the background, whether the application is launched in the foreground or not. Each time a job runs, it will attempt to upload all events stored. If it fails, because of a network issue for example, it will be retried later. It does not allow for a shorter delay. You can however configure a longer delay, by setting a higher value than '15' to the variable 'debouncingIntervalInMinutes'. Any value below 15 will be ignored, and the 15 minutes delay will remain.
