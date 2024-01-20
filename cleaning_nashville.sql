-- Cleaning Data in sql
select *
from NashvilleHousings

-- standardize sales_format
select saleDate, CONVERT(Date, saleDate) 
from NashvilleHousings

select saleDateConverted
from NashvilleHousings

ALTER TABLE NashvilleHousings
ADD saleDateConverted Date;

Update NashvilleHousings
set saleDateConverted = CONVERT(Date, saleDate)

-- Populate Property Address data
select *
from NashvilleHousings
where PropertyAddress is null
order by parcelID

select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousings a
JOIN NashvilleHousings b
ON a.parcelID = b.parcelID
AND   a.UniqueID <> b.UniqueID	
where a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousings a
JOIN NashvilleHousings b
ON a.parcelID = b.parcelID
AND   a.UniqueID <> b.UniqueID	
where a.PropertyAddress is null


-- Breaking Address into individual columns (Address, City, State)
SELECT PropertyAddress
FROM NashvilleHousings

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)  as PropertySplitAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))  as PropertySplitCity
FROM NashvilleHousings

ALTER TABLE NashvilleHousings
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousings
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)

ALTER TABLE NashvilleHousings
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousings
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

SELECT PropertySplitCity, PropertySplitAddress
FROM NashvilleHousings

-- Splitting owner's address 
SELECT 
	PARSENAME(Replace(OwnerAddress, ',', '.'),3) ,
	PARSENAME(Replace(OwnerAddress, ',', '.'),2),
	PARSENAME(Replace(OwnerAddress, ',', '.'),1)
FROM NashvilleHousings

ALTER TABLE NashvilleHousings
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousings
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3) 

ALTER TABLE NashvilleHousings
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousings
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2) 

ALTER TABLE NashvilleHousings
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousings
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1) 

SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM NashvilleHousings

-- Changing all the Y and N to Yes and No respectively
select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN  'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 
from NashvilleHousings

UPDATE NashVilleHousings
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN  'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 


select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousings
group by SoldAsVacant

--  Remove duplicates
WITH RowNumCTE as (
Select *,
	ROW_NUMBER() OVER 
	(PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
		ParcelID)
		Row_Num
from NashvilleHousings)
-- order by ParcelID)

Select *
from RowNumCTE
where Row_Num > 1
--order by PropertyAddress

-- Drop Columns
select *
from NashvilleHousings

ALTER TABLE NashvilleHousings
Drop column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousings
Drop column SaleDate

