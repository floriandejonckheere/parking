# Parking

![Continuous Integration](https://github.com/floriandejonckheere/parking/workflows/Continuous%20Integration/badge.svg)

Self-parking car simulation.

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

Click and drag to look around, scroll to zoom.

| **Key**                  | **Function**                    |
|--------------------------|---------------------------------|
| WASD                     | Car drive/reverse left/right    |
| Space                    | Brake                           |
| V                        | Toggle scene/car camera         |
| Q                        | Quit application                |
| **Scene camera options** |                                 |
| Arrow keys               | Camera forward/backward up/down |
| +/- (or =/-)             | Camera up/down                  |
| PgUp                     | Top-down view (scene camera)    |
| PgDn                     | Sideways view (scene camera)    |

## Contributing

1. Fork the repository (<https://github.com/floriandejonckheere/parking/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

See [LICENSE.md](LICENSE.md).

[1956 Fiat 500 Low Poly](https://skfb.ly/ooxzE) by Montero, used under [Creative Commons Attribution](http://creativecommons.org/licenses/by/4.0/).
