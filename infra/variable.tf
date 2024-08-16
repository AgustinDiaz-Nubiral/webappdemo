variable "location" {
  description = "The Azure Region in wich all resource groups should be created."
}

variable "rgname" {
  description = "The name of the resource group."
}

variable "createdby" {
  description = "The individual or team responsible for creating the resource."
}

variable "deadline" {
  description = "The date by which the project or task associated with the resource should be completed."
}

variable "owner" {
  description = "The individual or team responsible for maintaining and managing the resource."
}

variable "pod" {
  description = "The specific pod to which the resource belongs within Nubiral."
}

variable "project" {
  description = "The name of the project to which the resource is associated."
}

variable "coe" {
  description = "The Nubiral Coe which the resource belongs."
}
