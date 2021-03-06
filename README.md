# Baincd's custom-window-title

package name: custom-window-title-baincd

This is a fork of [pixilz's custom-window-title v1.0.4](https://github.com/pixilz/custom-window-title/tree/v1.0.4) with the following enhancements:

* Change `projectPath` (Path to project of open file)
* Change `projectName` (Directory name of project of open file)
* Add `projectManagerTitle` (Title from [Project Manager](https://atom.io/packages/project-manager))
* Add `fileIsModified`

[pixilz's custom-window-title](https://github.com/pixilz/custom-window-title) was forked from the [postcasio's custom-title](https://github.com/postcasio/custom-title) package as the owner has stopped updating for quite some time while there are stale bugs.

---

Set your own template for Atom's title bar. Uses [underscore.js templates](http://underscorejs.org/#template).

The following variables are available:

- `projectPath` (Path to project of open file)
- `projectName` (Directory name of project of open file)
- `projectManagerTitle` (Title from [Project Manager](https://atom.io/packages/project-manager))
- `filePath` (Path to current file)
- `fileInProject` (Boolean)
- `fileIsModified`
- `relativeFilePath` (Path to file relative to current project)
- `fileName` (File name)
- `gitHead`
- `gitAdded`
- `gitDeleted`
- `devMode`
- `safeMode` (always false, since the package will not be loaded in safe mode!)

In addition the following variables from `os` is available:

- `username`
- `hostname`

Plus the `atom` global, as usual.

Project and git variables always refer to the first path in your project.

## Examples

These examples can all be tested by going to the package settings and setting the template field.

### Filename and project path

```
<%= fileName %><% if (projectPath) { %> - <%= projectPath %><% } %>
```

### With Atom version

```
<%= fileName %><% if (projectPath) { %> - <%= projectPath %><% } %> - Atom <%= atom.getVersion() %>
```

### With the current git branch

```
<%= fileName %><% if (projectPath) { %> - <%= projectPath %><% if (gitHead) { %> [<%= gitHead %>]<% } %><% } %>
```

### With project name and current git branch
```
<%= fileName %><% if (projectName) { %> - <%= projectName %><% if (gitHead) { %> [<%= gitHead %>]<% } %><% } %>
```

### With hostname and username

```
<%= username %> @ <%= hostname %> : <%= fileName %><% if (projectPath) { %> - <%= projectPath %><% if (gitHead) { %> [<%= gitHead %>]<% } %><% } %>
```

### Project name display

```
<% if (projectName) { %> <%= projectName %> <% } %><% if (gitHead) { %> [ ⛕<%= gitHead %> ] <% } %> <%= fileName %><% if (filePath) { %> - <%= filePath %> <% } %>
```
