## ibuttonr: Functions for cleaning and loading ibutton data into R
[![Build Status](https://travis-ci.org/aammd/ibuttonr.png?branch=master)](https://travis-ci.org/aammd/ibuttonr)

ibuttons are common tools for measuring temperature over time. But, they're also slightly error-prone, and the data requires just a touch of cleaning. These convenience functions automate the reading of ibutton data and perform some elementary error checking.

## Installing ibuttonr

You can install ibuttonr directly from github using `devtools`:

```
install.packages("devtools")
devtools::install_github("aammd/ibuttonr")
```

## Using ibuttonr

1. Put all your ibutton files into a single directory. Don't put any other data here
2. Read all the files in that folder at once with `read_ibutton_folder()`

```
ibutton.data <- read_ibutton_folder(".")
```

3. Perform some checks (optional)
4. Convert list into data.frame with `ibuttons_to_data_frame()`

```
ibuttons_to_data_frame(ibutton.data)
```

See `vignette("loading_data")` for more details and some examples of error checking.




## License
Copyright 2014 Andrew MacDonald

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
