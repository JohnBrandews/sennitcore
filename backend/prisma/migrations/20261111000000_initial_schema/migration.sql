-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('CUSTOMER', 'DRIVER', 'ADMIN', 'TRANSIT_OFFICER');

-- CreateEnum
CREATE TYPE "DriverApplicationStatus" AS ENUM ('NOT_APPLIED', 'PENDING', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "VehicleType" AS ENUM ('MOTORCYCLE', 'CAR', 'VAN', 'TRUCK');

-- CreateEnum
CREATE TYPE "ParcelStatus" AS ENUM ('created', 'awaiting_confirmation', 'awaiting_driver_assignment', 'pending', 'assigned', 'awaiting_pickup', 'picked_up', 'collected', 'at_origin_transit_point', 'in_transit', 'arrived_at_transit_point', 'at_transit_point', 'at_destination', 'batch_transferred', 'out_for_delivery', 'locker_assigned', 'ready_for_locker_collection', 'in_locker', 'collected_from_locker', 'delivered_to_recipient', 'delivered', 'completed', 'delivery_unsuccessful', 'returned', 'tampering_alert', 'cancelled');

-- CreateEnum
CREATE TYPE "ReviewType" AS ENUM ('SERVICE', 'DRIVER', 'DELIVERY_SPEED', 'COMMUNICATION', 'OVERALL');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('PARCEL_CREATED', 'PARCEL_ASSIGNED', 'PARCEL_PICKED_UP', 'PARCEL_IN_TRANSIT', 'PARCEL_DELIVERED_TO_RECIPIENT', 'PARCEL_DELIVERED', 'PARCEL_COMPLETED', 'DRIVER_ASSIGNED', 'PAYMENT_RECEIVED', 'REVIEW_RECEIVED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'PAID', 'FAILED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "DriverStatus" AS ENUM ('PENDING_APPROVAL', 'APPROVED', 'REJECTED', 'ACTIVE', 'SUSPENDED', 'DEACTIVATED');

-- CreateEnum
CREATE TYPE "AssignmentStatus" AS ENUM ('ASSIGNED', 'ACKNOWLEDGED', 'COLLECTED', 'COMPLETED', 'CANCELLED', 'REJECTED');

-- CreateEnum
CREATE TYPE "BatchStatus" AS ENUM ('CREATED', 'IN_TRANSIT', 'SPLIT', 'MERGED', 'CLOSED');

-- CreateEnum
CREATE TYPE "LockerSize" AS ENUM ('SMALL', 'MEDIUM', 'LARGE', 'EXTRA_LARGE');

-- CreateEnum
CREATE TYPE "LockerStatus" AS ENUM ('AVAILABLE', 'RESERVED', 'OCCUPIED', 'OUT_OF_SERVICE', 'AWAITING_COLLECTION', 'COLLECTION_COMPLETED');

-- CreateEnum
CREATE TYPE "SealCondition" AS ENUM ('INTACT', 'DAMAGED', 'BROKEN', 'QR_MISMATCH');

-- CreateEnum
CREATE TYPE "TamperAlertType" AS ENUM ('SEAL_DAMAGED', 'SEAL_BROKEN', 'QR_MISMATCH', 'DUPLICATE_QR', 'SKIPPED_TRANSIT_POINT', 'INVALID_SEQUENCE', 'UNAUTHORISED_SCAN');

-- CreateEnum
CREATE TYPE "AlertStatus" AS ENUM ('OPEN', 'UNDER_INVESTIGATION', 'RESOLVED', 'ESCALATED');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "address" TEXT,
    "role" "UserRole" NOT NULL DEFAULT 'CUSTOMER',
    "licenseNumber" TEXT,
    "vehicleNumber" TEXT,
    "vehicleType" "VehicleType",
    "currentLat" DOUBLE PRECISION,
    "currentLng" DOUBLE PRECISION,
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "driverApplicationStatus" "DriverApplicationStatus" DEFAULT 'NOT_APPLIED',
    "driverApplicationDate" TIMESTAMP(3),
    "driverApplicationReason" TEXT,
    "driverApprovalDate" TIMESTAMP(3),
    "driverApprovedBy" TEXT,
    "driverRejectionReason" TEXT,
    "averageRating" DOUBLE PRECISION DEFAULT 0,
    "totalRatings" INTEGER NOT NULL DEFAULT 0,
    "totalDeliveries" INTEGER NOT NULL DEFAULT 0,
    "completedDeliveries" INTEGER NOT NULL DEFAULT 0,
    "cancelledDeliveries" INTEGER NOT NULL DEFAULT 0,
    "averageDeliveryTime" INTEGER,
    "onTimeDeliveryRate" DOUBLE PRECISION DEFAULT 0,
    "lastActiveAt" TIMESTAMP(3),
    "totalEarnings" DOUBLE PRECISION DEFAULT 0,
    "totalParcelsEverSent" INTEGER NOT NULL DEFAULT 0,
    "totalParcelsReceived" INTEGER NOT NULL DEFAULT 0,
    "preferredPaymentMethod" TEXT,
    "profilePicture" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "parcels" (
    "id" TEXT NOT NULL,
    "trackingNumber" TEXT NOT NULL,
    "parcelNumber" TEXT,
    "qrSealIdentifier" TEXT,
    "senderId" TEXT,
    "senderName" TEXT NOT NULL,
    "senderEmail" TEXT NOT NULL,
    "senderPhone" TEXT NOT NULL,
    "recipientId" TEXT,
    "recipientName" TEXT NOT NULL,
    "recipientEmail" TEXT NOT NULL,
    "recipientPhone" TEXT NOT NULL,
    "driverId" TEXT,
    "assignedAt" TIMESTAMP(3),
    "routeId" TEXT,
    "currentTransitPointId" TEXT,
    "pickupAddress" TEXT NOT NULL,
    "deliveryAddress" TEXT NOT NULL,
    "preferredPickupAt" TIMESTAMP(3),
    "deliveryMethod" TEXT,
    "currentLocation" TEXT,
    "status" "ParcelStatus" NOT NULL DEFAULT 'pending',
    "weight" DOUBLE PRECISION NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "category" TEXT,
    "dimensions" TEXT,
    "isFragile" BOOLEAN NOT NULL DEFAULT false,
    "description" TEXT,
    "value" DOUBLE PRECISION,
    "deliveryInstructions" TEXT,
    "notes" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "estimatedPickupTime" TIMESTAMP(3),
    "actualPickupTime" TIMESTAMP(3),
    "estimatedDeliveryTime" TIMESTAMP(3),
    "actualDeliveryTime" TIMESTAMP(3),
    "totalDeliveryTime" INTEGER,
    "deliveryAttempts" INTEGER NOT NULL DEFAULT 0,
    "deliveryFee" DOUBLE PRECISION,
    "paymentStatus" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "deliveredToRecipient" BOOLEAN NOT NULL DEFAULT false,
    "deliveryConfirmedAt" TIMESTAMP(3),
    "deliveryConfirmedBy" TEXT,
    "customerSignature" TEXT,
    "customerNotes" TEXT,
    "completedAt" TIMESTAMP(3),
    "completedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "parcels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "reviewerId" TEXT NOT NULL,
    "revieweeId" TEXT,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "reviewType" "ReviewType" NOT NULL,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "parcel_status_history" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "status" "ParcelStatus" NOT NULL,
    "location" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "updatedBy" TEXT,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,
    "imageUrl" TEXT,

    CONSTRAINT "parcel_status_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "actionUrl" TEXT,
    "parcelId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "readAt" TIMESTAMP(3),

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "delivery_proofs" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "customerSignature" TEXT,
    "recipientName" TEXT NOT NULL,
    "deliveredAt" TIMESTAMP(3) NOT NULL,
    "confirmedAt" TIMESTAMP(3) NOT NULL,
    "deliveredBy" TEXT NOT NULL,
    "confirmedBy" TEXT NOT NULL,
    "customerNotes" TEXT,
    "driverNotes" TEXT,

    CONSTRAINT "delivery_proofs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_tokens" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_profiles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customer_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "driver_profiles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "nationalId" TEXT,
    "routesServed" TEXT[],
    "currentRouteId" TEXT,
    "approvalStatus" "DriverStatus" NOT NULL DEFAULT 'PENDING_APPROVAL',
    "activationNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "driver_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "driver_documents" (
    "id" TEXT NOT NULL,
    "driverId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "publicId" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "driver_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "parcel_assignments" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "driverId" TEXT NOT NULL,
    "assignedBy" TEXT NOT NULL,
    "status" "AssignmentStatus" NOT NULL DEFAULT 'ASSIGNED',
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "acknowledgedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "rejectedAt" TIMESTAMP(3),
    "rejectionReason" TEXT,

    CONSTRAINT "parcel_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "routes" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "origin" TEXT NOT NULL,
    "destination" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "routes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transit_points" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "contact" TEXT,
    "routeId" TEXT,
    "officerId" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "transit_points_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "route_transit_points" (
    "id" TEXT NOT NULL,
    "routeId" TEXT NOT NULL,
    "transitPointId" TEXT NOT NULL,
    "sequence" INTEGER NOT NULL,
    "instructions" TEXT,

    CONSTRAINT "route_transit_points_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transit_point_officers" (
    "id" TEXT NOT NULL,
    "transitPointId" TEXT NOT NULL,
    "officerId" TEXT NOT NULL,
    "nominatedBy" TEXT,
    "nominatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transit_point_officers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "batches" (
    "id" TEXT NOT NULL,
    "batchNumber" TEXT NOT NULL,
    "routeId" TEXT NOT NULL,
    "driverId" TEXT,
    "parentBatchId" TEXT,
    "status" "BatchStatus" NOT NULL DEFAULT 'CREATED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "closedAt" TIMESTAMP(3),

    CONSTRAINT "batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "batch_parcels" (
    "id" TEXT NOT NULL,
    "batchId" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "addedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "loadedAt" TIMESTAMP(3),
    "loadedBy" TEXT,
    "removedAt" TIMESTAMP(3),

    CONSTRAINT "batch_parcels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "batch_events" (
    "id" TEXT NOT NULL,
    "batchId" TEXT NOT NULL,
    "transitPointId" TEXT,
    "type" TEXT NOT NULL,
    "notes" TEXT,
    "createdBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "batch_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transit_inspections" (
    "id" TEXT NOT NULL,
    "batchId" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "transitPointId" TEXT NOT NULL,
    "officerId" TEXT NOT NULL,
    "condition" "SealCondition" NOT NULL,
    "decision" TEXT NOT NULL,
    "notes" TEXT,
    "inspectedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transit_inspections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locker_stations" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "transitPointId" TEXT,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "openingHours" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "locker_stations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locker_compartments" (
    "id" TEXT NOT NULL,
    "stationId" TEXT NOT NULL,
    "compartmentNo" TEXT NOT NULL,
    "size" "LockerSize" NOT NULL,
    "status" "LockerStatus" NOT NULL DEFAULT 'AVAILABLE',
    "currentParcelId" TEXT,
    "lastMaintenance" TIMESTAMP(3),

    CONSTRAINT "locker_compartments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locker_assignments" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "compartmentId" TEXT NOT NULL,
    "assignedBy" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "collectedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),

    CONSTRAINT "locker_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locker_requests" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "requestedBy" TEXT NOT NULL,
    "stationId" TEXT,
    "size" "LockerSize" NOT NULL DEFAULT 'MEDIUM',
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "reviewedBy" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "locker_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locker_extension_requests" (
    "id" TEXT NOT NULL,
    "lockerAssignmentId" TEXT NOT NULL,
    "requestedBy" TEXT NOT NULL,
    "requestedMinutes" INTEGER NOT NULL,
    "reason" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "reviewedBy" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "locker_extension_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "collection_codes" (
    "id" TEXT NOT NULL,
    "lockerAssignmentId" TEXT NOT NULL,
    "codeHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "collection_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "parcel_seals" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "signedData" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "parcel_seals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "seal_scans" (
    "id" TEXT NOT NULL,
    "sealId" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "scannedBy" TEXT NOT NULL,
    "scannerRole" "UserRole" NOT NULL,
    "transitPointId" TEXT,
    "condition" "SealCondition" NOT NULL,
    "imageUrl" TEXT,
    "comments" TEXT,
    "previousStatus" "ParcelStatus",
    "currentStatus" "ParcelStatus",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "seal_scans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tamper_alerts" (
    "id" TEXT NOT NULL,
    "parcelId" TEXT NOT NULL,
    "sealScanId" TEXT,
    "type" "TamperAlertType" NOT NULL,
    "status" "AlertStatus" NOT NULL DEFAULT 'OPEN',
    "details" TEXT NOT NULL,
    "investigation" TEXT,
    "outcome" TEXT,
    "resolvedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolvedAt" TIMESTAMP(3),

    CONSTRAINT "tamper_alerts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "demand_forecasts" (
    "id" TEXT NOT NULL,
    "routeId" TEXT,
    "destination" TEXT,
    "periodStart" TIMESTAMP(3) NOT NULL,
    "periodEnd" TIMESTAMP(3) NOT NULL,
    "predictedVolume" DOUBLE PRECISION NOT NULL,
    "confidence" DOUBLE PRECISION,
    "recommendedCapacity" INTEGER,
    "model" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "demand_forecasts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "forecast_metrics" (
    "id" TEXT NOT NULL,
    "forecastId" TEXT NOT NULL,
    "actual" DOUBLE PRECISION NOT NULL,
    "error" DOUBLE PRECISION NOT NULL,
    "measuredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "forecast_metrics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "action" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT,
    "before" JSONB,
    "after" JSONB,
    "ipAddress" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_licenseNumber_key" ON "users"("licenseNumber");

-- CreateIndex
CREATE INDEX "users_name_idx" ON "users"("name");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_phone_idx" ON "users"("phone");

-- CreateIndex
CREATE INDEX "users_role_idx" ON "users"("role");

-- CreateIndex
CREATE INDEX "users_isActive_idx" ON "users"("isActive");

-- CreateIndex
CREATE INDEX "users_createdAt_idx" ON "users"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "parcels_trackingNumber_key" ON "parcels"("trackingNumber");

-- CreateIndex
CREATE UNIQUE INDEX "parcels_parcelNumber_key" ON "parcels"("parcelNumber");

-- CreateIndex
CREATE UNIQUE INDEX "parcels_qrSealIdentifier_key" ON "parcels"("qrSealIdentifier");

-- CreateIndex
CREATE INDEX "parcels_senderName_idx" ON "parcels"("senderName");

-- CreateIndex
CREATE INDEX "parcels_senderEmail_idx" ON "parcels"("senderEmail");

-- CreateIndex
CREATE INDEX "parcels_recipientName_idx" ON "parcels"("recipientName");

-- CreateIndex
CREATE INDEX "parcels_recipientEmail_idx" ON "parcels"("recipientEmail");

-- CreateIndex
CREATE INDEX "parcels_senderId_idx" ON "parcels"("senderId");

-- CreateIndex
CREATE INDEX "parcels_recipientId_idx" ON "parcels"("recipientId");

-- CreateIndex
CREATE INDEX "parcels_driverId_idx" ON "parcels"("driverId");

-- CreateIndex
CREATE INDEX "parcels_routeId_idx" ON "parcels"("routeId");

-- CreateIndex
CREATE INDEX "parcels_status_idx" ON "parcels"("status");

-- CreateIndex
CREATE INDEX "parcels_createdAt_idx" ON "parcels"("createdAt");

-- CreateIndex
CREATE INDEX "reviews_revieweeId_idx" ON "reviews"("revieweeId");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_parcelId_reviewerId_reviewType_key" ON "reviews"("parcelId", "reviewerId", "reviewType");

-- CreateIndex
CREATE UNIQUE INDEX "delivery_proofs_parcelId_key" ON "delivery_proofs"("parcelId");

-- CreateIndex
CREATE UNIQUE INDEX "customer_profiles_userId_key" ON "customer_profiles"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "driver_profiles_userId_key" ON "driver_profiles"("userId");

-- CreateIndex
CREATE INDEX "driver_profiles_currentRouteId_idx" ON "driver_profiles"("currentRouteId");

-- CreateIndex
CREATE INDEX "driver_documents_driverId_idx" ON "driver_documents"("driverId");

-- CreateIndex
CREATE INDEX "parcel_assignments_parcelId_idx" ON "parcel_assignments"("parcelId");

-- CreateIndex
CREATE INDEX "parcel_assignments_driverId_status_idx" ON "parcel_assignments"("driverId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "routes_name_key" ON "routes"("name");

-- CreateIndex
CREATE INDEX "transit_points_name_idx" ON "transit_points"("name");

-- CreateIndex
CREATE INDEX "transit_points_routeId_idx" ON "transit_points"("routeId");

-- CreateIndex
CREATE INDEX "transit_points_officerId_idx" ON "transit_points"("officerId");

-- CreateIndex
CREATE UNIQUE INDEX "route_transit_points_routeId_transitPointId_key" ON "route_transit_points"("routeId", "transitPointId");

-- CreateIndex
CREATE UNIQUE INDEX "route_transit_points_routeId_sequence_key" ON "route_transit_points"("routeId", "sequence");

-- CreateIndex
CREATE UNIQUE INDEX "transit_point_officers_officerId_key" ON "transit_point_officers"("officerId");

-- CreateIndex
CREATE INDEX "transit_point_officers_transitPointId_idx" ON "transit_point_officers"("transitPointId");

-- CreateIndex
CREATE UNIQUE INDEX "transit_point_officers_transitPointId_officerId_key" ON "transit_point_officers"("transitPointId", "officerId");

-- CreateIndex
CREATE UNIQUE INDEX "batches_batchNumber_key" ON "batches"("batchNumber");

-- CreateIndex
CREATE INDEX "batches_routeId_idx" ON "batches"("routeId");

-- CreateIndex
CREATE INDEX "batches_parentBatchId_idx" ON "batches"("parentBatchId");

-- CreateIndex
CREATE INDEX "batch_parcels_parcelId_idx" ON "batch_parcels"("parcelId");

-- CreateIndex
CREATE UNIQUE INDEX "batch_parcels_batchId_parcelId_key" ON "batch_parcels"("batchId", "parcelId");

-- CreateIndex
CREATE INDEX "batch_events_batchId_createdAt_idx" ON "batch_events"("batchId", "createdAt");

-- CreateIndex
CREATE INDEX "transit_inspections_batchId_inspectedAt_idx" ON "transit_inspections"("batchId", "inspectedAt");

-- CreateIndex
CREATE INDEX "transit_inspections_parcelId_inspectedAt_idx" ON "transit_inspections"("parcelId", "inspectedAt");

-- CreateIndex
CREATE INDEX "transit_inspections_transitPointId_officerId_idx" ON "transit_inspections"("transitPointId", "officerId");

-- CreateIndex
CREATE UNIQUE INDEX "locker_stations_name_key" ON "locker_stations"("name");

-- CreateIndex
CREATE INDEX "locker_stations_transitPointId_idx" ON "locker_stations"("transitPointId");

-- CreateIndex
CREATE INDEX "locker_compartments_stationId_status_size_idx" ON "locker_compartments"("stationId", "status", "size");

-- CreateIndex
CREATE UNIQUE INDEX "locker_compartments_stationId_compartmentNo_key" ON "locker_compartments"("stationId", "compartmentNo");

-- CreateIndex
CREATE INDEX "locker_assignments_parcelId_idx" ON "locker_assignments"("parcelId");

-- CreateIndex
CREATE INDEX "locker_assignments_compartmentId_idx" ON "locker_assignments"("compartmentId");

-- CreateIndex
CREATE INDEX "locker_requests_parcelId_status_idx" ON "locker_requests"("parcelId", "status");

-- CreateIndex
CREATE INDEX "locker_requests_status_createdAt_idx" ON "locker_requests"("status", "createdAt");

-- CreateIndex
CREATE INDEX "locker_extension_requests_lockerAssignmentId_status_idx" ON "locker_extension_requests"("lockerAssignmentId", "status");

-- CreateIndex
CREATE INDEX "locker_extension_requests_status_createdAt_idx" ON "locker_extension_requests"("status", "createdAt");

-- CreateIndex
CREATE INDEX "collection_codes_lockerAssignmentId_idx" ON "collection_codes"("lockerAssignmentId");

-- CreateIndex
CREATE UNIQUE INDEX "parcel_seals_parcelId_key" ON "parcel_seals"("parcelId");

-- CreateIndex
CREATE UNIQUE INDEX "parcel_seals_identifier_key" ON "parcel_seals"("identifier");

-- CreateIndex
CREATE INDEX "seal_scans_parcelId_createdAt_idx" ON "seal_scans"("parcelId", "createdAt");

-- CreateIndex
CREATE INDEX "seal_scans_sealId_idx" ON "seal_scans"("sealId");

-- CreateIndex
CREATE INDEX "tamper_alerts_parcelId_status_idx" ON "tamper_alerts"("parcelId", "status");

-- CreateIndex
CREATE INDEX "demand_forecasts_routeId_periodStart_idx" ON "demand_forecasts"("routeId", "periodStart");

-- CreateIndex
CREATE INDEX "forecast_metrics_forecastId_idx" ON "forecast_metrics"("forecastId");

-- CreateIndex
CREATE INDEX "audit_logs_entityType_entityId_idx" ON "audit_logs"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "audit_logs_userId_createdAt_idx" ON "audit_logs"("userId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_tokenHash_key" ON "refresh_tokens"("tokenHash");

-- CreateIndex
CREATE INDEX "refresh_tokens_userId_idx" ON "refresh_tokens"("userId");

-- AddForeignKey
ALTER TABLE "parcels" ADD CONSTRAINT "parcels_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parcels" ADD CONSTRAINT "parcels_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parcels" ADD CONSTRAINT "parcels_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_parcelId_fkey" FOREIGN KEY ("parcelId") REFERENCES "parcels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_revieweeId_fkey" FOREIGN KEY ("revieweeId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parcel_status_history" ADD CONSTRAINT "parcel_status_history_parcelId_fkey" FOREIGN KEY ("parcelId") REFERENCES "parcels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parcel_status_history" ADD CONSTRAINT "parcel_status_history_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_parcelId_fkey" FOREIGN KEY ("parcelId") REFERENCES "parcels"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_proofs" ADD CONSTRAINT "delivery_proofs_parcelId_fkey" FOREIGN KEY ("parcelId") REFERENCES "parcels"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_proofs" ADD CONSTRAINT "delivery_proofs_deliveredBy_fkey" FOREIGN KEY ("deliveredBy") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_proofs" ADD CONSTRAINT "delivery_proofs_confirmedBy_fkey" FOREIGN KEY ("confirmedBy") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "driver_profiles" ADD CONSTRAINT "driver_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
