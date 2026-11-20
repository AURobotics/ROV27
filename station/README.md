# station

This is the station sub-project folder, containing the source code for the remote-control GUI.

## Contributing

### Project Setup

After cloning the mono-repo, open the `station/` folder inside your favorite text editor or IDE.

### Pre-requisites

#### Installing Pixi [↗️](https://pixi.prefix.dev/latest/installation/)

**Windows**
Pixi
```pwsh
winget install prefix-dev.pixi
```
and MSVC
```pwsh
winget install --id Microsoft.VisualStudio.2022.BuildTools --source winget --force --accept-package-agreements --accept-source-agreements --override "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --wait /norestart"
```


**Linux/ MacOS**
```sh
curl -fsSL https://pixi.sh/install.sh | bash
```

#### Installing project dependencies

Make sure you are in a pixi-activated shell
```sh
pixi shell
```

Then, run:
```sh
pixi install
```

Then:
```sh
colcon build
```

### Startup

run:
```sh
pixi run station
```
