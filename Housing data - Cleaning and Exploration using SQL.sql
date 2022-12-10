/* Cleaning Data in SQL Queries */

Select *
From housing.dataset1;

Select count(*)
From housing.dataset1;

----------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From housing.dataset1
Where PropertyAddress is null;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From housing.dataset1 a
JOIN housing.dataset1 b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
    Where a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From housing.dataset1 a
JOIN housing.dataset1 b
	on (a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID)
Where a.PropertyAddress is null;

----------------------------------------------------------------------------------------------------------------------------------------

-- Splitting address into individual Columns (Address, City, State)

Select PropertyAddress
From housing.dataset1;
-- Where PropertyAddress is null;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From housing.dataset1;


ALTER TABLE housing.dataset1
Add PropertySplitAddress Nvarchar(255);

Update housing.dataset1
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

ALTER TABLE housing.dataset1
Add PropertySplitCity Nvarchar(255);

Update housing.dataset1
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

Select OwnerAddress
From housing.dataset1;

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From housing.dataset1;

ALTER TABLE housing.dataset1
Add OwnerSplitAddress Nvarchar(255);

Update housing.dataset1
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

ALTER TABLE housing.dataset1
Add OwnerSplitCity Nvarchar(255);

Update housing.dataset1
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

ALTER TABLE housing.dataset1
Add OwnerSplitState Nvarchar(255);

Update housing.dataset1
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

Select *
From housing.dataset1;

----------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant) as total_count
From housing.dataset1
Group by SoldAsVacant
order by total_count;

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END as 'Yes/No'
From housing.dataset1;

Update housing.dataset1
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END;
----------------------------------------------------------------------------------------------------------------------------------------
 
 -- Remove Duplicates
 
 with rownumCTE as(
 (select *,
	Row_number() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID) row_num
 from housing.dataset1 
 order by ParcelID)
 )
 delete  
 from rownumCTE
 where row_num > 1;
 
----------------------------------------------------------------------------------------------------------------------------------------

select *
from housing.dataset1;

select LandValue, max(salePrice) as Max_Price
from housing.dataset1;

select max(YearBuilt) 
from housing.dataset1;

delete from housing.dataset1
where LandValue = 0;

delete from housing.dataset1
where YearBuilt = 0;

select PropertySplitCity,max(TotalValue),YearBuilt,SalePrice
from housing.dataset1 
group by PropertySplitCity
having YearBuilt > 1990;




 



