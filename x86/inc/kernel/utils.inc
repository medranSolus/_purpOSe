;/**
; * @file utils.h
; * @author Marek Machliński
; * @brief Header with utility functions for assembly.
; * @version 0.0.1_a
; * @date 01-04-2020
; * 
; * @copyright Copyright (c) 2020
; * 
; */
%ifndef __UTILS_INC__
%define __UTILS_INC__

%define MAX_PROCESSORS 1

;/**
; * @brief Number of processors on current machine.
; * 
; */
EXTERN PROCESSOR_COUNT

;/**
; * @brief Panic function, when everything else failed...
; * 
; */
EXTERN panic
;/**
; * @brief Exclude current processor from further execution.
; * 
; */
EXTERN _disable_processor

%endif ; __UTILS_INC__