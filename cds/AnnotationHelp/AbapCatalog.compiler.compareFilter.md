If true, the filter conditions of the path expressions of the view are compared. If the same filter condition occurs, the associated join expression is only **evaluated once**. Otherwise a separate join expression is created and evaluated for each filter condition.

The predefined annotation AbapCatalog.compiler.compareFilter can be used to specify whether the filter conditions are compared for the path expressions of a view. If the filter condition matches, the associated join expression is evaluated only once, which generally improves performance. Otherwise a separate join expression is created and evaluated for each filter condition. The results sets of both configurations can, however, differ.

