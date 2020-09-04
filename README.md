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

## Usage
##### Track metric
```
IotTracker.shared.trackMetric(name: "name", tag: "tag", value: value)
```

##### Track log
```
IotTracker.shared.trackLog(logStream: "logStream", message: "message", value: value)
```
