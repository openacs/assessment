<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<master>
  <property name="link_all">1</property>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @context@ not nil><property name="context">@context;noquote@</property></if>
    <else><if @context_bar@ not nil><property name="context">@context_bar;noquote@</property></if></else>
  <if @doc_type@ not nil><property
  name="doc_type">@doc_type;noquote@</property></if>
  <if @title@ not nil><property name="title">@title;noquote@</property></if>
  <property name="header_stuff">
<style type="text/css">
/* Re-enable the breadcrumb bar -- useful for site-wide admins */
#breadcrumbs {
  display: inline;
}
</style>
  </property>

<slave>

