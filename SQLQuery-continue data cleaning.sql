
select* from portfolio..NashvilleHousing

-- standardize date format 
select SaleDateConverted,CONVERT(Date,SaleDate)
from portfolio..NashvilleHousing

update portfolio..NashvilleHousing
SET SaleDate =CONVERT(Date,SaleDate)

Alter table portfolio..NashvilleHousing
Add SaleDateConverted Date

update portfolio..NashvilleHousing
SET SaleDateConverted =CONVERT(Date,SaleDate)


--populate property Address data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolio..NashvilleHousing a
join portfolio..NashvilleHousing b
on a.ParcelID =b.ParcelID
And a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null


update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolio..NashvilleHousing a
join portfolio..NashvilleHousing b
on a.ParcelID =b.ParcelID
And a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null

-- breaking out Address into Individual Column (Address,city,state)

select PropertyAddress
from portfolio..NashvilleHousing

select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as PropertyAddress

From portfolio..NashvilleHousing


Alter table portfolio..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update portfolio..NashvilleHousing
SET PropertySplitAddress =substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table portfolio..NashvilleHousing
Add PropertySplitCity nvarchar(255)

update portfolio..NashvilleHousing
SET PropertySplitCity =substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from portfolio..NashvilleHousing

Alter table portfolio..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update portfolio..NashvilleHousing
SET OwnersplitAddress =PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table portfolio..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update portfolio..NashvilleHousing
SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter table portfolio..NashvilleHousing
Add OwnerSplitState nvarchar(255)

update portfolio..NashvilleHousing
SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select * from portfolio..NashvilleHousing

-- change Y AND N to Yes and NO in "Sold as Vacant" field
select distinct(SoldAsVacant),count(SoldAsVacant)
from portfolio..NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
case
    when SoldAsVacant ='Y' Then 'yes'
	when SoldAsVacant ='N' then 'No'
	Else SoldAsVacant
	END
from portfolio..NashvilleHousing




update portfolio..NashvilleHousing
SET SoldAsVacant =
case
    when SoldAsVacant ='Y' Then 'yes'
	when SoldAsVacant ='N' then 'No'
	Else SoldAsVacant
END

-- remove duplicate

with RowNumCte AS(
select *,
ROW_NUMBER() over (
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by
UniqueId
)row_num

from portfolio..NashvilleHousing
)
DELETE from RowNumCte 
where row_num>1
--order by PropertyAddress


--delete unused column
alter table portfolio..NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table portfolio..NashvilleHousing
drop column SaleDate

select * from portfolio..NashvilleHousing


