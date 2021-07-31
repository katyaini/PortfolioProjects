--CLEANING DATA IN SQL QUERIES

Select *
from PortfolioProject..NashvilleHousing

--Standardize Date Format

Select SaleDate, CONVERT (date, SaleDate)
from PortfolioProject..NashvilleHousing



alter table NashvilleHousing
Add SaleDateConverted Date;


Select SaleDateConverted
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDateConverted=convert (date,SaleDate)

Select SaleDateConverted
from PortfolioProject..NashvilleHousing

--Populate Property Address Data

Select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--Select a.ParcelID,a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
--from PortfolioProject..NashvilleHousing a
--join PortfolioProject..NashvilleHousing b
--    on a.ParcelID=b.ParcelID
--	AND a.[UniqueID ]<>b.[UniqueID ]
--where a.PropertyAddress is null

update a
SET PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Select a.ParcelID,a.PropertyAddress,b.ParcelID, b.PropertyAddress
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Addess into individual Columns( Address, City, State)

Select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) AS Address
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
Add PropertySpiltAddress nvarchar(255);

Update NashvilleHousing
SET PropertySpiltAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table NashvilleHousing
Add PropertySpiltCity nvarchar(255);

Update NashvilleHousing
SET PropertySpiltCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))



Select OwnerAddress
from PortfolioProject..NashvilleHousing

Select 
PARSENAME(replace(OwnerAddress,',' , '.'), 3 ),
PARSENAME(replace(OwnerAddress,',' , '.'), 2 ),
PARSENAME(replace(OwnerAddress,',' , '.'), 1)
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing 
add OwnerAdressSplit nvarchar(255)

Update NashvilleHousing
SET OwnerAdressSplit=PARSENAME(replace(OwnerAddress,',' , '.'), 3 )

alter table NashvilleHousing 
add OwnerCityplit nvarchar(255)

Update NashvilleHousing
SET OwnerCitySplit=PARSENAME(replace(OwnerAddress,',' , '.'), 2 )

alter table NashvilleHousing 
add OwnerStateSplit nvarchar(255)

Update NashvilleHousing
SET OwnerStateSplit=PARSENAME(replace(OwnerAddress,',' , '.'), 3 )

Select *
from PortfolioProject..NashvilleHousing

--Change Y AND N in "Sold as Vacant" field to Yes and No

Select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject..NashvilleHousing 
Group by SoldAsVacant
order by 2



select SoldAsVacant
,CASE When SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  else SoldAsVacant 
	  end
from NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=
CASE When SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  else SoldAsVacant 
	  end
from NashvilleHousing



--Remove Duplicates


WITH RowNumCTE AS (
Select *,
    row_number() over(partition by ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference ORDER BY ParcelID) row_num
from PortfolioProject..NashvilleHousing
)
--DELETE 
--from RowNumCTE
--WHERE ROW_NUM>1
SELECT *
from RowNumCTE
WHERE ROW_NUM>1


--DELETE UNUSED COLUMNS

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress,PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate
