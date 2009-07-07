;;;; By Nikodemus Siivola <nikodemus@random-state.net>, 2009.
;;;;
;;;; Permission is hereby granted, free of charge, to any person
;;;; obtaining a copy of this software and associated documentation files
;;;; (the "Software"), to deal in the Software without restriction,
;;;; including without limitation the rights to use, copy, modify, merge,
;;;; publish, distribute, sublicense, and/or sell copies of the Software,
;;;; and to permit persons to whom the Software is furnished to do so,
;;;; subject to the following conditions:
;;;;
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
;;;; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
;;;; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;;;; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(in-package :sb-cga)

;;;; PREDICATES AND SUBTYPES

(declaim (ftype (sfunction (t) boolean) vecp)
         (inline vecp))
(defun vecp (object)
  "Return true if OBJECT is a VEC.."
  (typep object 'vec))

(declaim (ftype (sfunction (t) boolean) pointp)
         (inline pointp))
(defun pointp (object)
  "Return true if OBJECT is a point."
  (and (vecp object) (= 1.0 (aref object 3))))

(deftype point ()
  "Point type: subtype of VEC consisting of those VECs whose 4th element is
1.0."
  `(satisfies pointp))

(declaim (ftype (sfunction (t) boolean) vector3p)
         (inline vector3p))
(defun vector3p (object)
  "Return true if OBJECT is a 3D vector."
  (and (vecp object) (= 0.0 (aref object 3))))

(deftype vector3 ()
  "3D vector type: subtype of VEC consisting of those VECs whose 4th element
is 0.0."
  `(satisfied vector3p))

;;;; CONSTRUCTORS

(declaim (ftype (sfunction () vec) alloc-vec)
         (inline alloc-vec))
(defun alloc-vec ()
  "Allocate a zero-initialized VEC."
  (make-array 4 :element-type 'single-float))

(declaim (ftype (sfunction (single-float single-float single-float single-float) vec) vec)
         (inline vec))
(defun vec (a b c d)
  "Allocate 4D vector [A, B, C, D]."
  (make-array 4 :element-type 'single-float :initial-contents (list a b c d)))

(declaim (ftype (sfunction (single-float single-float single-float) vec) point)
         (inline point))
(defun point (x y z)
  "Allocate point \(X,Y,Z)."
  (vec x y z 1.0))

(declaim (ftype (sfunction (single-float single-float single-float) vec) vector3)
         (inline vector3))
(defun vector3 (a b c)
  "Allocate 3D vector [A,B,C]."
  (vec a b c 0.0))

;;;; CONVERSIONS

(declaim (ftype (sfunction (vec) vec) point->vector3)
         (inline point->vector3))
(defun point->vector3 (point)
  "Return 3D vector corresponding to coordinates of POINT. Outside safe code
4th element of POINT is not asserted to be 1.0."
  (safe-check (pointp point))
  (vector3 (aref point 0) (aref point 1) (aref point 2)))

(declaim (ftype (sfunction (vec) vec) vector3->point)
         (inline vector3->point))
(defun vector3->point (location)
  "Return point for corresponding to the 3D vector LOCATION. Outside safe code
4th element of LOCATION is not asserted to be 0.0."
  (safe-check (vector3p location))
  (point (aref location 0) (aref location 1) (aref location 2)))

;;;; COMPARISON

(declaim (ftype (sfunction (vec vec) boolean) vec=)
         (inline vec=))
(defun vec= (a b)
  "Return true if VEC A and VEC B are elementwise identical."
  (sb-cga-vm:%vec= a b))