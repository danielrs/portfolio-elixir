# greed

Seriously? Another grid system? Well... **yes**!

There are a *lot* of different grid systems (semantic.gs, Jeet, etc), but most of them
are either lacking in features or are not available in Less; most good grid systems are
only available to Sass and Stylus.

## Features

Despite the name, the *greed* system is very simple while allowing for the following features:

* non-global settings, allowing you to change it's behaviour multiple times
* right-to-left columns, a feature missing from most Less grid systems
* column cycling
* fluid and responsive

## Usage

Use the `.grid` mixin in any child scope, avoid using it in the **global** scope. For example:

This is wrong:
```less
.grid;
.child-scope {...}
.other-child-scope {...}
```

This is right:
```less
.child-scope {
  .grid;
  ...
}
.child-scope {
  .grid(@column-float: right);
  ...
}
```

The signature of the `.grid` mixin is:

```less
.grid(@grid-width: 100%, @gutter: 5%, @column-float: left)
```

After using the `.grid` mixin, the `.row` and `.column` mixins become available, their signature is:

```less
.row()
```

```less
.column(@column-span, @columns, @cycle: 0)
```

`.row` Basically sets up the element that will hold the columns (clearfix, etc).
`.column` Sets up a column width, float, etc.

## Examples

### Mobile first list with cycle at 2 and 3 columns

```less
ul.list {
  .grid;
  .row;

  @media screen and (min-width: 720px) and (max-width: 1023px) {
    li.list-item { .column(1, 2, 2); }
  }

  @media screen and (min-width: 1024px)
    li.list-item { .column(1, 3, 3); }
  }
}
```

## License

[MIT](https://github.com/DanielRS/greed/blob/master/LICENSE)
