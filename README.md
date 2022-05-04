# climbdir.nvim

A neovim lib-plugin to climb directory to search project root marker.

## Functions

### `climb({start_path}, {marker}, {*opts})`

Open a file in background floatwin.

Parameters:

- `{start_path}`: a path starting climbing.
- `{marker}`: a function check if a path is matched.
             They accept a path to check and return true if the path is matched.
             You can use functions in "climbdir.marker" module.
             See [Markers](#markers).

- `{*opts}`:  dictionary of options:
    - `halt` (function) optional: a function checking if a path is to stop climbing.

## Markers

### `has_directory({name})`

Get a marker to accept a directory has a directory with fixed name.

Parameters:

- `{name}`  (string) A name of the directory as marker.


### `has_readable_file({name})`

Get a marker to accept a directory has a readable file with fixed name.

Parameters:

- `{name}`  (string) A name of the file as marker.


### `has_writable_file({name})`

Get a marker to accept a directory has a writable file with fixed name.

Parameters:

- `{name}`  (string) A name of the file as marker.


### `glob({pattern})`

Get a marker to accept a directory has files/directories in glob.

Parameters:

- `{pattern}`  (string) A pattern to search as marker.

### `one_of({markers...})`

Get a marker to accepts in case of any marker accepts.

Parameters:

- `{markers...}`  (function) marker.

### `all_of({markers...})`

Get a marker to accepts in case of all markers accept.

Parameters:

- `{markers...}`  (function) marker.

## Examples

Climb to a directory having `deno.json` or `deps.ts` without
`package.json` nor `node_modules/` in subdirectories.

```lua
local climbdir = require("climbdir")
local marker = require("climbdir.marker")
climbdir.climb(
    "/tmp/foo/bar/baz",
    marker.one_of(
        marker.has_readable_file("deno.json"),
        marker.has_readable_file("deps.ts"),
    ),
    {
        halt = marker.one_of(
            marker.has_readable_file("package.json"),
            marker.has_directory("node_modules"),
        ),
    },
)
```

## LICENSE

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg)](http://www.opensource.org/licenses/MIT)

This is distributed under the [MIT License](http://www.opensource.org/licenses/MIT).
