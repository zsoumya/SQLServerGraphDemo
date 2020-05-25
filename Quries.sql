-- Get all entities associated with entity C
SELECT ep.EntityId AS [ParentId], ep.Name AS [ParentName], ec.EntityId AS [ChildId], ec.Name AS [ChildName]
FROM dbo.Entity ep, dbo.Entity_ChildEntity ece, dbo.Entity ec
WHERE MATCH (ep-(ece)->ec)
AND (ep.Name = 'C' OR ec.Name = 'C')

-- Get all entities associated with entity C with relation
SELECT 'Parent' AS [Relation], ep.EntityId AS [ParentId], ep.Name AS [ParentName], ec.EntityId AS [ChildId], ec.Name AS [ChildName]
FROM dbo.Entity ep, dbo.Entity_ChildEntity ece, dbo.Entity ec
WHERE MATCH (ep-(ece)->ec)
AND ep.Name = 'C'
UNION
SELECT 'Child' AS [Relation], ep.EntityId AS [ParentId], ep.Name AS [ParentName], ec.EntityId AS [ChildId], ec.Name AS [ChildName]
FROM dbo.Entity ep, dbo.Entity_ChildEntity ece, dbo.Entity ec
WHERE MATCH (ep-(ece)->ec)
AND ec.Name = 'C'

-- Get all stores for entity C
SELECT e.EntityId, e.Name, s.StoreId, s.Name, es.Percentage
FROM dbo.Entity e, dbo.Entity_Store es, dbo.Store s
WHERE MATCH (e-(es)->s)
AND e.Name = 'C'

-- Get all owners and entities associated with store S1
SELECT 'Parent Entity' AS [Relation], e.EntityId, e.Name, s.StoreId, s.Name, es.Percentage
FROM dbo.Entity e, dbo.Entity_Store es, dbo.Store s
WHERE MATCH (e-(es)->s)
AND s.Name = 'S1'
UNION
SELECT 'Owner Operator' AS [Relation], o.OwnerOperatorId, o.Name, s.StoreId, s.Name, os.Percentage
FROM dbo.OwnerOperator o, dbo.OwnerOperator_Store os, dbo.Store s
WHERE MATCH (o-(os)->s)
AND s.Name = 'S1'
