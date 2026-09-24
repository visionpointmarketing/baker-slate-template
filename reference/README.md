# /reference

Baker's **current** Slate branding files, as supplied by Charlie on the ClickUp
task (VPM-46834). Drop them here unchanged:

- `build.xslt`
- `build.css`
- `build-fonts.css`

Nothing in this folder ships. It exists so the files we hand back can be
diffed against what Baker's instance runs today.

## Why this matters

`shared/build.xslt` was written against a known-good Slate page template from a
previous implementation, not against Baker's own. Before deploying, check
Baker's current `build.xslt` for anything instance-specific:

- the `<template path="..."/>` framework reference
- extra `<link>` or `<script>` includes (mobile globals, analytics, chat)
- any inline `<style>` block beyond Slate's standard one

And check their current `build.css` section by section for Slate UI rules that
our section 6 does not cover. Anything their instance depends on has to survive
the swap.
