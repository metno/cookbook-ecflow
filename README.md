# ecflow-cookbook

TODO: Sets up an ECMWF ecflow server and client

## Supported Platforms

Only ubuntu-14.04 so far. 

## Attributes

See attribues/default.rb

## Usage

### ecflow::default

Include `ecflow` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ecflow::default]"
  ]
}
```

## License and Authors

Author:: Espen (<espenm@met.no>)
