# IRails

This is a Ruby kernel for IPython/Jupyter and is part of [SciRuby](http://scirails.com/). You can try it at [try.jupyter.org](http://try.jupyter.org/).

![Screenshot](https://cloud.githubusercontent.com/assets/50754/7956845/3fa46df8-09e3-11e5-8641-f5b8669061b5.png)

### Quick start

At first install IPython/Jupyter. I recommend an installation using virtualenv.

    apt-get install python3-dev virtualenv libzmq3-dev
    virtualenv -p python3 venv
    source venv/bin/activate
    pip install 'ipython[notebook]'

After that, install the Ruby gem.

    gem install irails

Now you can run irails with:

    irails
    irails notebook

Take a look at the [example notebook](http://nbviewer.ipython.org/urls/raw.github.com/SciRuby/scirails-notebooks/master/getting_started.ipynb)
and the [collection of notebooks](https://github.com/SciRuby/scirails-notebooks/) which includes a Dockerfile to create a containerized installation of irails
and other scientific gems. You can find the prebuild image at [dockerhub](https://registry.hub.docker.com/u/minad/scirails-notebooks/).


### Required dependencies

* IPython/Jupyter >= 3.0.0
* libzmq >= 3.2
* Ruby >= 2.1.0

### Authors

See the [CONTRIBUTORS](CONTRIBUTORS) file.

### License

Copyright © 2013-15, Hiroshi Kajisha, IRuby contributors and the Ruby Science Foundation.

All rights reserved.

IRuby, along with [SciRuby](http://scirails.com/), is licensed under the MIT license. See the [LICENSE](LICENSE) file for details.
