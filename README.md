# Parking

![Continuous Integration](https://github.com/floriandejonckheere/parking/workflows/Continuous%20Integration/badge.svg)

Self-parking car simulation.

<a href="https://github.com/floriandejonckheere/parking/raw/master/screenrecording0.gif"><img src="https://github.com/floriandejonckheere/parking/raw/master/screenrecording0.gif" width="49%" height="auto"></a>
<a href="https://github.com/floriandejonckheere/parking/raw/master/screenshot0.png"><img src="https://github.com/floriandejonckheere/parking/raw/master/screenshot0.png" width="49%" height="auto"></a>
<a href="https://github.com/floriandejonckheere/parking/raw/master/screenshot1.png"><img src="https://github.com/floriandejonckheere/parking/raw/master/screenshot1.png" width="49%" height="auto"></a>


## Installation

Install the prerequisites:

```sh
# OSX
$ brew install glfw3

# Ubuntu
$ sudo apt-get install libglfw3
```
Clone the repository, and install the dependencies:

```sh
$ bundle
```

## Usage

Run `bin/parking --debug --automatic --algorithm=simple` to start the simulation.
Run `bin/parking --help` to see all available commands and their arguments.

## Controls

### Camera

Click and drag to look around, scroll to zoom.

| **Key**                  | **Function**                    |
|--------------------------|---------------------------------|
| V                        | Toggle scene/car camera         |
| Q                        | Quit application                |
| **Scene camera options** |                                 |
| Arrow keys               | Camera forward/backward up/down |
| +/- (or =/-)             | Camera up/down                  |
| PgUp                     | Top-down view (scene camera)    |
| PgDn                     | Sideways view (scene camera)    |

### Car

The movement of the car is controlled by the algorithm.
You can run the simulation with manual controls as well:

```
  bin/parking --manual
```

| **Key**                  | **Function**                    |
|--------------------------|---------------------------------|
| WASD                     | Car drive/reverse left/right    |
| Space                    | Brake                           |

## Contributing

1. Fork the repository (<https://github.com/floriandejonckheere/parking/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

See [LICENSE.md](LICENSE.md).

[1956 Fiat 500 Low Poly](https://skfb.ly/ooxzE) by Montero, used under [Creative Commons Attribution](http://creativecommons.org/licenses/by/4.0/).
