---
citekey: "{{citekey}}"
title: "{{title | replace('"', "'")}}"
authors: "{{authors}}"
year: {{date | format("YYYY")}}
venue: "{{publicationTitle}}{{conferenceName}}{{publisher}}"
doi: "{{DOI}}"
zotero: "{{desktopURI}}"
stream: 
market: 
status: skeleton
tags:
  - literature-review
---
{% persist "review" %}

<!-- Opening paragraph: place the paper, then say plainly how it relates to my work. -->

<!-- Full treatment below for direct methodological templates. For background or tooling
     papers, delete these and use "## Major differences to mine" + "## Standout features"
     instead, or follow the paper's own shape. Two things appear either way: how it
     differs from what I'm building, and what's worth taking from it. -->

#### Gap it's addressing

#### Data and setup

#### Model architecture and training

#### Findings

<!-- 5 to 6 bullets. Each a full argued paragraph. Bold the key term when a bullet opens
     on one. Quote the actual figures inline. Merge anything that shares a conclusion. -->

#### Limitations

<!-- 5 to 6 bullets. This is usually where a premise I doubt lands hardest, so let the
     earlier mentions be a clause rather than a paragraph. -->

#### Why this matters for my project

<!-- 6 to 8 bullets. Converts each finding into a decision for my own build, tied back to
     the CSE. Not a recap. No gap-matrix IDs anywhere: name the thing itself. -->

<!-- Before saving: (1) over budget? merge bullets that share a conclusion. (2) said twice?
     every criticism gets exactly one home. (3) any display formula that one sentence of
     prose would cover? Three or four display formulas, three or four images. -->

{% endpersist %}

---

> [!info]- Raw annotations from Zotero
> Working material, not part of the review. Re-run the import to pull in new highlights. Delete this block once the review is written.

{% persist "annotations" %}
{% if annotations.length > 0 %}

##### Gap it's addressing <!-- purple -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Purple" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Data and setup <!-- blue -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Blue" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Method and architecture <!-- yellow -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Yellow" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Findings and numbers <!-- green -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Green" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Limitations and blockers <!-- red -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Red" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Formulas and figures to reproduce <!-- orange -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Orange" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Take for my build <!-- magenta -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Magenta" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

##### Unsorted <!-- grey and anything else -->
{% for annotation in annotations %}{% if annotation.colorCategory == "Gray" or annotation.colorCategory == "Grey" %}
- {% if annotation.annotatedText %}"{{annotation.annotatedText}}"{% endif %} [p. {{annotation.pageLabel}}]({{annotation.desktopURI}}){% if annotation.comment %}
	- {{annotation.comment}}{% endif %}{% if annotation.imageRelativePath %}
	- ![[{{annotation.imageRelativePath}}]]{% endif %}{% endif %}{% endfor %}

{% endif %}
{% endpersist %}

---

{{bibliography}}
